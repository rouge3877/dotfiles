#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 初始化统计变量
declare -i TOTAL_PACKAGES=0
declare -i INSTALLED=0
declare -i SKIPPED=0
declare -i FAILED=0

# 基础包声明
declare -A DEPENDENCIES=(
    ["essentials"]="gcc gdb make cmake llvm clang g++ ctags"
    ["python"]="python3 python3-pip python3-venv"
    ["node"]="nodejs npm"
    ["libs"]="libjson-c libjsoncpp libcurl openssl ncurses"
    ["tools"]="git vim tmux htop neofetch wget zip unzip fzf trash-cli stow"
    ["debug"]="valgrind strace ltrace gdb"
    ["docs"]="man-db man-pages tldr pandoc"
    ["network"]="net-tools nmap openssh"
    ["gui"]="wireshark-qt code"
    ["latex"]="texlive texlive-lang texlive-core texlive-latexextra texlive-fontsextra texlive-langchinese"
    ["misc"]="cmatrix sl"
    ["markdown"]="glow md-tui"
)

# 包名映射表（仅需要特殊处理的包）
declare -A PKG_MAP=(
    # Debian/Ubuntu
    ["libjson-c:debian"]="libjson-c-dev"
    ["libjsoncpp:debian"]="libjsoncpp-dev"
    ["libcurl:debian"]="libcurl4-openssl-dev"
    ["ncurses:debian"]="libncurses5-dev"
    ["code:debian"]="code"

    # Fedora/CentOS
    ["libjson-c:fedora"]="json-c-devel"
    ["libjsoncpp:fedora"]="jsoncpp-devel"
    ["libcurl:fedora"]="libcurl-devel"
    ["code:fedora"]="code"

    # Arch
    ["python3:arch"]="python"
    ["python3-pip:arch"]="python-pip"
    ["python3-venv:arch"]="python"
    ["code:arch"]="visual-studio-code-bin"
    ["libjson-c:arch"]="c-json"
    ["libjsoncpp:arch"]="jsoncpp"
    ["libcurl:arch"]="curl"
    ["ncurses:arch"]="ncurses"
)

# 系统检测
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="${ID:-unknown}"
        OS_LIKE="${ID_LIKE:-}"
    else
        echo -e "${RED}Cannot detect OS${NC}"
        exit 1
    fi

    case "$OS_ID" in
        debian|ubuntu) OS="debian" ;;
        fedora|centos) OS="fedora" ;;
        arch|manjaro) OS="arch" ;;
        *) echo -e "${RED}Unsupported OS: $OS_ID${NC}"; exit 1 ;;
    esac
}

# 权限检查
check_permissions() {
    if [ "$(id -u)" -ne 0 ]; then
        if command -v sudo &>/dev/null; then
            echo -e "${YELLOW}Proceeding with sudo...${NC}"
            exec sudo "$0" "$@"
        else
            echo -e "${RED}Root permissions required${NC}"
            exit 1
        fi
    fi
}

# 包管理器初始化
init_pkg_manager() {
    case "$OS" in
        debian)
            UPDATE_CMD="apt-get update -qq"
            INSTALL_CMD="apt-get install -yq --no-install-recommends"
            PKG_CHECK="dpkg -s"
            ;;
        fedora)
            UPDATE_CMD="dnf check-update -q"
            INSTALL_CMD="dnf install -y --skip-broken"
            PKG_CHECK="rpm -q"
            ;;
        arch)
            UPDATE_CMD="pacman -Sy --noconfirm"
            INSTALL_CMD="pacman -S --needed --noconfirm"
            PKG_CHECK="pacman -Q"
            ;;
    esac
}

# 预处理
pre_install() {
    echo -e "${BLUE}Updating package index...${NC}"
    if ! eval "$UPDATE_CMD"; then
        echo -e "${YELLOW}Failed to update package index${NC}"
        exit 1
    fi

    if [ "$OS" = "arch" ]; then
        if ! grep -q '^\[archlinuxcn\]' /etc/pacman.conf; then
            echo -e "${BLUE}Adding Arch Linux CN mirrors...${NC}"
            echo "[archlinuxcn]" >> /etc/pacman.conf
            echo "Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
            pacman -Sy --noconfirm archlinuxcn-keyring || exit 1
        fi

        if ! grep -q '^\[arch4edu\]' /etc/pacman.conf; then
            echo -e "${BLUE}Adding Arch 4 Edu mirrors...${NC}"
            echo "[arch4edu]" >> /etc/pacman.conf
            echo "Server = https://mirrors.tuna.tsinghua.edu.cn/arch4edu/\$arch" >> /etc/pacman.conf
            pacman -Sy --noconfirm arch4edu-keyring || exit 1
        fi
    fi
}

# 包名转换
map_package() {
    local pkg=$1
    local os=$2

    # 优先检查精确匹配
    if [ -n "${PKG_MAP["$pkg:$os"]}" ]; then
        echo "${PKG_MAP["$pkg:$os"]}"
    elif [ -n "${PKG_MAP["$pkg:$OS_ID"]}" ]; then
        echo "${PKG_MAP["$pkg:$OS_ID"]}"
    else
        echo "$pkg"
    fi
}

# 安装单个包
install_single_pkg() {
    local raw_pkg=$1
    local pkg=$(map_package "$raw_pkg" "$OS")

    ((TOTAL_PACKAGES++))
    
    if eval "$PKG_CHECK $pkg" &>/dev/null; then
        echo -e "  ${GREEN}[*] $raw_pkg${NC} (Installed)"
        ((SKIPPED++))
        return 0
    fi

    echo -e "  ${YELLOW}[ ] Installing $raw_pkg...${NC}"
    if eval "$INSTALL_CMD $pkg" &>/dev/null; then
        echo -e "\r  ${GREEN}[*] $raw_pkg${NC}"
        ((INSTALLED++))
        return 0
    else
        echo -e "\r  ${RED}[x] $raw_pkg${NC}"
        ((FAILED++))
        return 1
    fi
}

# 主安装流程
main_install() {
    detect_os
    check_permissions "$@"
    init_pkg_manager
    pre_install

    echo -e "${BLUE}Beginning installation...${NC}"
    for category in "${!DEPENDENCIES[@]}"; do
        echo -e "\n${BLUE}=== Installing $category ===${NC}"
        for pkg in ${DEPENDENCIES[$category]}; do
            install_single_pkg "$pkg"
        done
    done

    # 显示统计
    echo -e "\n${BLUE}=== Installation Summary ===${NC}"
    printf "${BLUE}Total packages: %3d${NC}\n" $TOTAL_PACKAGES
    printf "${GREEN}Successfully installed: %3d${NC}\n" $INSTALLED
    printf "${YELLOW}Skipped:              %3d${NC}\n" $SKIPPED
    printf "${RED}Failed:               %3d${NC}\n" $FAILED

    [ $FAILED -gt 0 ] && exit 1 || exit 0
}

main_install "$@"
