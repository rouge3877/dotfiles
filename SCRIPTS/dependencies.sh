#!/usr/bin/env bash
set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 初始化统计变量
TOTAL_PACKAGES=0
INSTALLED=0
SKIPPED=0
FAILED=0

# 依赖项声明
declare -A DEPENDENCIES=(
    ["build"]="gcc gdb make cmake g++ python3 python3-pip nodejs npm"
    ["libs"]="libjson-c-dev libjsoncpp-dev libcurl4-openssl-dev curl libncurses5-dev"
    ["tools"]="git vim tmux htop neofetch wget zip unzip fzf trash-cli valgrind strace sudo pandoc"
    ["docs"]="man-db man-pages tldr"
    ["network"]="net-tools iputils-ping nmap openssh-server"
    ["gui"]="wireshark wireshark-qt wireshark-cli code"
    ["latex"]="texlive-full texlive-lang-*"
    ["fun"]="cmatrix sl go-music"
)

# 不同发行版的包名映射
declare -A PKG_MAP=(
    ["arch:build"]="gcc gdb make cmake g++ python python-pip nodejs npm"
    ["arch:libs"]="json-c jsoncpp curl ncurses"
    ["arch:gui"]="wireshark-qt wireshark-cli visual-studio-code-bin"
    ["arch:network"]="net-tools iputils nmap openssh"
    ["arch:latex"]="texlive-most texlive-lang-cjk"
    ["arch:fun"]="cmatrix sl go-music"
    ["fedora:build"]="gcc gdb make cmake gcc-c++ python3 python3-pip nodejs npm"
    ["fedora:libs"]="json-c-devel jsoncpp-devel libcurl-devel ncurses-devel"
    ["fedora:network"]="net-tools iputils nmap openssh-server"
    ["fedora:latex"]="texlive-scheme-full"
)

# 系统信息检测
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="${ID:-unknown}"
        OS_LIKE="${ID_LIKE:-}"
        VERSION_ID="${VERSION_ID:-}"
    else
        echo -e "${RED}Failed to detect OS${NC}"
        exit 1
    fi

    case "$OS_ID" in
        debian|ubuntu|pop|linuxmint) OS="debian" ;;
        fedora|centos|rhel|ol) OS="fedora" ;;
        arch|manjaro|endeavouros) OS="arch" ;;
        *) echo -e "${RED}Unsupported OS: $OS_ID${NC}"; exit 1 ;;
    esac
}

# 权限检查
check_permissions() {
    if [ "$(id -u)" -ne 0 ]; then
        if command -v sudo &>/dev/null; then
            echo -e "${YELLOW}Re-running script with sudo...${NC}"
            exec sudo "$0" "$@"
        else
            echo -e "${RED}Root privileges required but sudo not available${NC}"
            exit 1
        fi
    fi
}

# 包管理器命令
init_pkg_manager() {
    case "$OS" in
        debian)
            UPDATE_CMD="apt-get update -qq"
            INSTALL_CMD="apt-get install -yq"
            PKG_CHECK="dpkg -l"
            ;;
        fedora)
            UPDATE_CMD="dnf check-update -q || [ \$? -eq 100 ]"
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

# 安装预处理
pre_install() {
    # 更新包数据库
    echo -e "${BLUE}Updating package database...${NC}"
    eval "$UPDATE_CMD" || {
        echo -e "${YELLOW}Package database update failed, attempting to continue...${NC}"
    }

    # 为Arch系统添加第三方仓库
    if [ "$OS" = "arch" ]; then
        # 添加archlinuxcn仓库
        if ! grep -q '^\[archlinuxcn\]' /etc/pacman.conf; then
            echo -e "${BLUE}Adding archlinuxcn repository...${NC}"
            echo "[archlinuxcn]" >> /etc/pacman.conf
            echo "Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
            # 导入密钥
            pacman -Sy --noconfirm archlinuxcn-keyring || {
                echo -e "${RED}Failed to import archlinuxcn keyring${NC}"
                exit 1
            }
        fi

        # 添加arch4edu仓库
        if ! grep -q '^\[arch4edu\]' /etc/pacman.conf; then
            echo -e "${BLUE}Adding arch4edu repository...${NC}"
            echo "[arch4edu]" >> /etc/pacman.conf
            echo "Server = https://mirrors.ustc.edu.cn/arch4edu/\$arch" >> /etc/pacman.conf
            # 导入密钥
            pacman -Sy --noconfirm arch4edu-keyring || {
                echo -e "${RED}Failed to import arch4edu keyring${NC}"
                exit 1
            }
        fi

        # 更新包数据库
        pacman -Sy --noconfirm || {
            echo -e "${YELLOW}Package database update failed, attempting to continue...${NC}"
        }
    fi
}

# 包安装函数
install_packages() {
    local category=$1
    local -n packages=$2

    echo -e "\n${BLUE}=== Installing ${category} packages ===${NC}"
    
    for pkg in ${packages}; do
        ((TOTAL_PACKAGES++))
        local pkg_name
        
        # 获取系统特定包名
        if [ -n "${PKG_MAP["$OS:$category"]+x}" ]; then
            pkg_name="${PKG_MAP["$OS:$category"]}"
        elif [ -n "${PKG_MAP["$OS_ID:$category"]+x}" ]; then
            pkg_name="${PKG_MAP["$OS_ID:$category"]}"
        else
            pkg_name="$pkg"
        fi

        # 检查是否已安装
        if eval "$PKG_CHECK $pkg_name" &>/dev/null; then
            echo -e "  ${GREEN}[✓] $pkg_name${NC} (already installed)"
            ((SKIPPED++))
            continue
        fi

        # 执行安装
        echo -e "  ${YELLOW}[ ] Installing $pkg_name...${NC}"
        if eval "$INSTALL_CMD $pkg_name" &>/dev/null; then
            echo -e "\r  ${GREEN}[✓] $pkg_name${NC}"
            ((INSTALLED++))
        else
            echo -e "\r  ${RED}[✗] $pkg_name${NC}"
            ((FAILED++))
        fi
    done
}

# 主安装流程
main() {
    detect_os
    check_permissions "$@"
    init_pkg_manager
    pre_install

    # 安装所有分类的包
    for category in "${!DEPENDENCIES[@]}"; do
        install_packages "$category" DEPENDENCIES["$category"]
    done

    # 显示统计信息
    echo -e "\n${BLUE}=== Installation Summary ===${NC}"
    printf "Total packages:    %3d\n" "$TOTAL_PACKAGES"
    printf "${GREEN}Successfully installed: %3d${NC}\n" "$INSTALLED"
    printf "${YELLOW}Skipped (existing):   %3d${NC}\n" "$SKIPPED"
    printf "${RED}Failed installations: %3d${NC}\n" "$FAILED"

    # 如果有失败则返回非零状态码
    [ $FAILED -gt 0 ] && exit 1 || exit 0
}

# 执行主函数
main "$@"