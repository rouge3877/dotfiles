#!/bin/bash

# Configuration Files
# $@ is the list of modules to setup, e.g., cli/tmux, gui/kitty
# if no argument is provided, setup refers to `pkg_list.json` for package lists

CONFIG_FILE="./pkg_list.json"


PACMAN_CACHE="/var/cache/pacman/pkg"
NPM_PACKAGES=()
AUR_PACKAGES=()

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'


DOTFILE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$DOTFILE_ROOT/cli"
GUI_DIR="$DOTFILE_ROOT/gui"

# Installation Statistics
declare -A STATS=(
    [pacman_total]=0
    [pacman_installed]=0
    [npm_total]=0
    [npm_installed]=0
    [aur_total]=0
    [aur_installed]=0
    [failed]=0
)

# Animation States
SPINNER=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# Dependency Checks ###########################################################
check_arch() {
    if ! grep -qi 'arch' /etc/os-release; then
        echo -e "${RED}Error: This script requires Arch Linux or derivatives${NC}"
        exit 1
    fi
}

check_privileges() {
    if (( EUID != 0 )); then
        if command -v sudo &>/dev/null; then
            exec sudo -E "$0" "$@"
        else
            echo -e "${RED}Error: Root privileges required${NC}"
            exit 1
        fi
    fi
}

# Configuration Handling ######################################################
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Error: Missing configuration file $CONFIG_FILE${NC}"
        exit 1
    fi

    local config=$(cat "$CONFIG_FILE")

    NPM_PACKAGES=($(jq -r '.npm[]' <<< "$config"))
    AUR_PACKAGES=($(jq -r '.aur[]' <<< "$config"))
 
    declare -gA PACMAN_PACKAGES
    while read -r category; do
        PACMAN_PACKAGES["$category"]=$(jq -r ".pacman.\"$category\"[]" <<< "$config")
    done < <(jq -r '.pacman | keys[]' <<< "$config")
}

# Repository Management #######################################################
configure_repos() {
    echo -e "\n${BLUE}▷ Configuring repositories...${NC}"
    
    declare -A repos=(
        ["archlinuxcn"]="https://mirrors.ustc.edu.cn/archlinuxcn/\$arch"
        ["arch4edu"]="https://mirrors.tuna.tsinghua.edu.cn/arch4edu/\$arch"
    )

    for repo in "${!repos[@]}"; do
        if ! grep -q "^\[$repo\]" /etc/pacman.conf; then
            echo -e "${YELLOW}➜ Adding $repo repository${NC}"
            printf "\n[%s]\nServer = %s\n" "$repo" "${repos[$repo]}" >> /etc/pacman.conf
        fi
    done

    pacman -Sy --noconfirm archlinuxcn-keyring arch4edu-keyring &>/dev/null
}

# Package Installation ########################################################
install_spinner() {
    local pid=$1
    local msg=$2
    local i=0
    
    while kill -0 $pid &>/dev/null; do
        echo -ne "\r  ${SPINNER[$i]} ${msg}"
        i=$(( (i+1) % 10 ))
        sleep 0.1
    done
    echo -ne "\r\033[K"
}

install_pacman() {
    # update keyring
    pacman -S --noconfirm archlinux-keyring &>/dev/null
    pacman -S --noconfirm archlinuxcn-keyring &>/dev/null
    pacman -S --noconfirm arch4edu-keyring &>/dev/null

    for category in "${!PACMAN_PACKAGES[@]}"; do
        echo -e "\n${BLUE}▐▌ ${category}${NC}"
        for pkg in ${PACMAN_PACKAGES[$category]}; do
            ((STATS[pacman_total]++))
            
            if pacman -Qi "$pkg" &>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $pkg (exists)"
                ((STATS[pacman_installed]++))
                continue
            fi

            echo -e "  ${YELLOW}➜${NC} Installing $pkg..."
            pacman -S --needed --noconfirm "$pkg" &>/dev/null &
            install_spinner $! "$pkg installation"
            
            if pacman -Qi "$pkg" &>/dev/null; then
                echo -e "\r  ${GREEN}✓${NC} $pkg"
                ((STATS[pacman_installed]++))
            else
                echo -e "\r  ${RED}✗${NC} $pkg"
                ((STATS[failed]++))
            fi
        done
    done
}

install_npm() {
    (( ${#NPM_PACKAGES[@]} )) || return
    
    echo -e "\n${BLUE}▷ Installing global npm packages${NC}"
    STATS[npm_total]=${#NPM_PACKAGES[@]}
    
    for pkg in "${NPM_PACKAGES[@]}"; do
        if npm list -g "$pkg" &>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $pkg (exists)"
            ((STATS[npm_installed]++))
            continue
        fi

        echo -e "  ${YELLOW}➜${NC} Installing $pkg..."
        npm install -g "$pkg" &>/dev/null &
        install_spinner $! "$pkg installation"
        
        if npm list -g "$pkg" &>/dev/null; then
            echo -e "\r  ${GREEN}✓${NC} $pkg"
            ((STATS[npm_installed]++))
        else
            echo -e "\r  ${RED}✗${NC} $pkg"
            ((STATS[failed]++))
        fi
    done
}

install_aur() {
    (( ${#AUR_PACKAGES[@]} )) || return
    
    echo -e "\n${BLUE}▷ Installing AUR packages${NC}"
    STATS[aur_total]=${#AUR_PACKAGES[@]}
    
    if ! command -v yay &>/dev/null; then
        echo -e "${YELLOW}➜ Installing yay...${NC}"
        install_yay || return
    fi

    for pkg in "${AUR_PACKAGES[@]}"; do
        if yay -Qi "$pkg" &>/dev/null; then
            echo -e "  ${GREEN}✓${NC} $pkg (exists)"
            ((STATS[aur_installed]++))
            continue
        fi

        echo -e "  ${YELLOW}➜${NC} Installing $pkg..."
        yay -S --needed --noconfirm "$pkg" &>/dev/null &
        install_spinner $! "$pkg installation"
        
        if yay -Qi "$pkg" &>/dev/null; then
            echo -e "\r  ${GREEN}✓${NC} $pkg"
            ((STATS[aur_installed]++))
        else
            echo -e "\r  ${RED}✗${NC} $pkg"
            ((STATS[failed]++))
        fi
    done
}

install_yay() {
    local tmpdir=$(mktemp -d)
    
    echo -e "${YELLOW}➜ Cloning yay repository...${NC}"
    git clone https://aur.archlinux.org/yay.git "$tmpdir" &>/dev/null || return 1
    
    (
        cd "$tmpdir" || exit 1
        makepkg -si --needed --noconfirm &>/dev/null
    )
    
    local ret=$?
    rm -rf "$tmpdir"
    return $ret
}


parse_dep() {
    check_arch
    check_privileges "$@"
    local yaml_file="$1"
    # format like this:
    # pkg:
    #   - git
    #   - vim
    #   - lolcat
    #   - gource

    # npm:
    #   - gitmoji-cli

    pkg_lists=()
    local in_pkg_section=0
    while IFS= read -r line; do
        # Check for the start of the pkg section
        if [[ $line =~ ^pkg: ]]; then
            in_pkg_section=1
            continue
        fi
        # If we reach another section, stop processing pkg section
        if [[ $line =~ ^[a-zA-Z0-9_]+: ]] && [[ $in_pkg_section -eq 1 ]]; then
            break
        fi
        # If we are in the pkg section, collect package names
        if [[ $in_pkg_section -eq 1 && $line =~ ^[[:space:]]*-[[:space:]]*(.+) ]]; then
            pkg_lists+=("${BASH_REMATCH[1]}")
        fi
    done < "$yaml_file"

    npm_lists=()
    local in_npm_section=0
    while IFS= read -r line; do
        # Check for the start of the npm section
        if [[ $line =~ ^npm: ]]; then
            in_npm_section=1
            continue
        fi
        # If we reach another section, stop processing npm section
        if [[ $line =~ ^[a-zA-Z0-9_]+: ]] && [[ $in_npm_section -eq 1 ]]; then
            break
        fi
        # If we are in the npm section, collect package names
        if [[ $in_npm_section -eq 1 && $line =~ ^[[:space:]]*-[[:space:]]*(.+) ]]; then
            npm_lists+=("${BASH_REMATCH[1]}")
        fi
    done < "$yaml_file"

    for pkg in "${pkg_lists[@]}"; do
        echo -e "\n${BLUE}▷ Processing package: $pkg${NC}"
        sudo pacman -S --needed --noconfirm "$pkg" &>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Successfully installed $pkg${NC}"
        else
            echo -e "${RED}✗ Failed to install $pkg${NC}"
        fi
        echo -e "\n${BLUE}▷ Finished processing package: $pkg${NC}"
    done

    for npm_pkg in "${npm_lists[@]}"; do
        echo -e "\n${BLUE}▷ Processing npm package: $npm_pkg${NC}"
        npm install -g "$npm_pkg" &>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Successfully installed $npm_pkg${NC}"
        else
            echo -e "${RED}✗ Failed to install $npm_pkg${NC}"
        fi
        echo -e "\n${BLUE}▷ Finished processing npm package: $npm_pkg${NC}"
    done
}

# Main Execution Flow #########################################################
main() {
    check_arch
    check_privileges "$@"

    local packages_to_setup=()
    local global_install="true"
    for arg in "$@"; do
        if [[ "$arg" == "-g" || "$arg" == "--global" ]]; then
            global_install="false"
            continue
        else
            global_install="false"
            packages_to_setup+=("$arg")
        fi
    done

    if [ ${#packages_to_setup[@]} -eq 0 ]; then
        cli_list=( $(find "$CLI_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;) )
        gui_list=( $(find "$GUI_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;) )
        for i in "${!cli_list[@]}"; do cli_list[i]="cli/${cli_list[i]}"; done
        for i in "${!gui_list[@]}"; do gui_list[i]="gui/${gui_list[i]}"; done

        packages_to_setup+=( "${cli_list[@]}" )
        packages_to_setup+=( "${gui_list[@]}" )

    fi

    if [ "$global_install" == "false" ]; then
        for pkg in "${packages_to_setup[@]}"; do
            local yaml_file="$DOTFILE_ROOT/$pkg/dependency.yaml"
            if [ -f "$yaml_file" ]; then
                echo -e "\n${BLUE}▷ Processing $pkg dependencies...${NC}"
                parse_dep "$yaml_file"
            else
                echo -e "\n${YELLOW}➜ No dependency file found for $pkg, skipping...${NC}"
            fi
        done

        echo -e "\n${BLUE}▷ Skipping global package installation as per user request.${NC}"
        exit 0
    fi


    if [[ ! -f $CONFIG_FILE ]]; then
        echo -e "\n${RED}Error: Configuration file not found at $CONFIG_FILE${NC}"
        echo -e "Please provide a valid path to the configuration file as an argument.\n"
        exit 1
    fi

    # jq is required for JSON parsing
    # if jq is not installed, install it
    if ! pacman -Qi jq &>/dev/null; then
        echo -e "${YELLOW}➜ Installing jq...${NC}"
        pacman -S --needed --noconfirm jq &>/dev/null || exit 1
    fi
    load_config
    configure_repos
    
    echo -e "\n${BLUE}▷ Starting system package installation${NC}"
    install_pacman
    install_aur
    install_npm

    # Summary Report
    echo -e "\n${BLUE}▷ Installation Summary"
    echo "──────────────────────────────────────────"
    printf "${BLUE}Arch Packages:${NC} %d/%d installed\n" \
        ${STATS[pacman_installed]} ${STATS[pacman_total]}
    printf "${BLUE}AUR Packages:${NC}  %d/%d installed\n" \
        ${STATS[aur_installed]} ${STATS[aur_total]}
    printf "${BLUE}NPM Packages:${NC}  %d/%d installed\n" \
        ${STATS[npm_installed]} ${STATS[npm_total]}
    echo "──────────────────────────────────────────"
    printf "${RED}Failed installations: %d${NC}\n" ${STATS[failed]}
    echo "──────────────────────────────────────────"

    (( STATS[failed] > 0 )) && exit 1 || exit 0
}

main "$@"
