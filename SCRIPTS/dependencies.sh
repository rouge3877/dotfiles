#!/bin/bash

# Configuration Files
# $1 - Path to the configuration file (default: ./pkg_list.json)

if [[ -n $1 ]]; then
    CONFIG_FILE="$1"
else
    CONFIG_FILE="./pkg_list.json"
    if [[ ! -f $CONFIG_FILE ]]; then
        echo -e "\n${RED}Error: Configuration file not found at $CONFIG_FILE${NC}"
        echo -e "Please provide a valid path to the configuration file as an argument.\n"
        exit 1
    fi
fi

PACMAN_CACHE="/var/cache/pacman/pkg"
NPM_PACKAGES=()
AUR_PACKAGES=()

# Color Definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Main Execution Flow #########################################################
main() {
    check_arch
    check_privileges "$@"
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
