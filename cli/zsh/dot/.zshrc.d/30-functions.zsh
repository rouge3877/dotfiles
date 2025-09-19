#######################################################
# ~/.zshrc.d/30-functions.zsh - Zsh functions configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores all Zsh function definitions.

# Example: mkcd() { mkdir -p "$1" && cd "$1"; }
#######################################################


########### File management ###########

# A function that can specify the directory to search
fzfdir () {
    local dir="$1"
    if [ -z "$dir" ]; then
        dir="."
    fi
    
    find "$dir" -type f | fzf --preview 'less {}' --bind 'focus:transform-header:file --brief {}' --tmux --layout reverse --border top
}


# Make directory and change into it
mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Extract any type of archive
# Depending on: zip, tar, gzip, bzip2, unzip, uncompress, unrar, 7z
# Usage: extract <file>
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


########### Proxy management ###########
proxy_on() {

    if [[ -n $PROXY_SERVER && -n $PROXY_PORT ]]; then
        echo "Using custom proxy server and port: $PROXY_SERVER:$PROXY_PORT"
        export https_proxy=http://$PROXY_SERVER:$PROXY_PORT;
        export http_proxy=http://$PROXY_SERVER:$PROXY_PORT;
        export all_proxy=socks5://$PROXY_SERVER:$PROXY_PORT;
        echo "Proxy on"
        return
    fi

    if [[ -n $PROXY_SERVER ]]; then
        echo "Using custom proxy server: $PROXY_SERVER:7897"
        export https_proxy=http://$PROXY_SERVER:7897;
        export http_proxy=http://$PROXY_SERVER:7897;
        export all_proxy=socks5://$PROXY_SERVER:7897;
        echo "Proxy on"
        return
    fi

    if [[ -n $PROXY_PORT ]]; then
        echo "Using custom proxy port: $PROXY_PORT"
        export https_proxy=http://127.0.0.1:$PROXY_PORT;
        export http_proxy=http://127.0.0.1:$PROXY_PORT;
        export all_proxy=socks5://127.0.0.1:$PROXY_PORT;
        echo "Proxy on"
        return
    fi

    export https_proxy=http://127.0.0.1:7897;
    export http_proxy=http://127.0.0.1:7897;
    export all_proxy=socks5://127.0.0.1:7897;
    echo "Proxy on"
}

proxy_off() {
    unset https_proxy;
    unset http_proxy;
    unset all_proxy;
    echo "Proxy off"
}

proxy_print() {
    echo "https_proxy: $https_proxy"
    echo "http_proxy: $http_proxy"
    echo "all_proxy: $all_proxy"
}


########### Git helpers ###########
# Git ignore file
# https://www.gitignore.io/
gig() {
    curl -sL "https://www.toptal.com/developers/gitignore/api/$@"
}

# 定义颜色常量（根据使用场景选择格式）
# 用于提示符(PS1/RPROMPT)的zsh格式
local zsh_color_info="%F{green}"
local zsh_color_branch="%F{blue}"
local zsh_color_hash="%F{yellow}"
local zsh_color_dirty="%F{red}"
local zsh_color_remote="%F{magenta}"
local zsh_color_reset="%f"

# 用于echo输出的ANSI转义序列格式
local ansi_color_info="\033[32m"      # 绿色
local ansi_color_branch="\033[34m"    # 蓝色
local ansi_color_hash="\033[33m"      # 黄色
local ansi_color_dirty="\033[31m"     # 红色
local ansi_color_remote="\033[35m"    # 品红色
local ansi_color_reset="\033[0m"      # 重置颜色

# Git仓库状态检查
function is_inside_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# 获取当前分支或commit hash
function get_git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$branch" ]; then
        # 分离头状态（detached HEAD）
        git rev-parse --short HEAD 2>/dev/null | xargs printf "➦ %s"
    else
        echo $branch
    fi
}

# 获取仓库状态标志
function get_git_status() {
    local status_flags=""
    
    # 检查未提交的修改
    git status --porcelain | grep -E '^[MADRC]' >/dev/null && \
    status_flags+="*"
    
    # 检查未暂存的修改
    git status --porcelain | grep -E '^.[MADRC]' >/dev/null && \
    status_flags+="+"
    
    # 检查未跟踪的文件
    git status --porcelain | grep -E '^\?\?' >/dev/null && \
    status_flags+="%"
    
    # 检查stash存在性
    git rev-parse --verify --quiet refs/stash >/dev/null && \
    status_flags+="$"
    
    [ -n "$status_flags" ] && echo " $status_flags"
}

# 获取远程同步状态
function get_remote_status() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [ -z "$branch" ] || [ "$branch" = "HEAD" ] && return
    
    # 获取远程跟踪分支
    local remote=$(git config branch.${branch}.remote)
    [ -z "$remote" ] && return
    
    local merge_branch=$(git config branch.${branch}.merge)
    local upstream="${remote}/${merge_branch#refs/heads/}"
    
    # 比较本地和远程的差异
    local ahead=$(git rev-list --count ${upstream}..HEAD 2>/dev/null)
    local behind=$(git rev-list --count HEAD..${upstream} 2>/dev/null)
    
    local rstatus=""
    [ $ahead -gt 0 ] && rstatus+="↑${ahead}"
    [ $behind -gt 0 ] && rstatus+="↓${behind}"
    
    [ -n "$rstatus" ] && echo " ${rstatus}"
}

# 综合Git信息显示 - 用于echo输出
function get_git_prompt() {
    is_inside_git_repo || return
    
    local info=""
    info+="${ansi_color_branch}$(get_git_branch)${ansi_color_reset}"
    info+="${ansi_color_hash}@$(git rev-parse --short HEAD 2>/dev/null)${ansi_color_reset}"
    info+="${ansi_color_dirty}$(get_git_status)${ansi_color_reset}"
    info+="${ansi_color_remote}$(get_remote_status)${ansi_color_reset}"
    
    echo -e "[${info}]"
}

# 综合Git信息显示 - 用于zsh提示符(PS1/RPROMPT)
function get_git_prompt_zsh() {
    is_inside_git_repo || return
    
    local info=""
    info+="${zsh_color_branch}$(get_git_branch)${zsh_color_reset}"
    info+="${zsh_color_hash}@$(git rev-parse --short HEAD 2>/dev/null)${zsh_color_reset}"
    info+="${zsh_color_dirty}$(get_git_status)${zsh_color_reset}"
    info+="${zsh_color_remote}$(get_remote_status)${zsh_color_reset}"
    
    echo "[${info}]"
}



########### About Network ###########
# Get public IP address
get_public_ip() {
    local ip=$(curl -s "http://whatismyip.akamai.com/")
    
    if [[ -n $http_proxy ]]; then
        # italic if behind proxy
        echo -e "\e[3m$ip\e[0m"
    else
        echo $ip
    fi
}

get_local_ip() {
    if [[ $1 == "-4" ]]; then
        local ip=$( ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | head -n 1 )
        
        if [[ -n $http_proxy ]]; then
            # italic if behind proxy
            echo -e "\e[3m$ip\e[0m" | tr -d '\n'
        else
            echo $ip | tr -d '\n'
        fi
        elif [[ $1 == "-6" ]]; then
        local ipv6=$( ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}' | tail -n 1 )
        if [[ -z $ipv6 ]]; then
            echo "IPv6 is not supported" | tr -d '\n'
            return
        fi
        if [[ -n $http_proxy ]]; then
            # italic if behind proxy
            echo -e "\e[3m$ipv6\e[0m" | tr -d '\n'
        else
            echo $ipv6 | tr -d '\n'
        fi
    else
        echo "Usage: get_local_ip [-4|-6]"
    fi
}

# Get the MAC address of the network interface
get_mac_address() {
    local mac=$(ip link show | awk '/link\/ether/ {print $2}' | head -n 1)
    
    if [[ -n $http_proxy ]]; then
        # italic if behind proxy
        echo -e "\e[3m$mac\e[0m" | tr -d '\n'
    else
        echo $mac | tr -d '\n'
    fi
}


########### About System Monitor ###########

# Get the OS name
get_os_name() {
    local os=$(cat /etc/os-release | awk -F= '/^NAME/ {print $2}' | tr -d '"' | awk '{print $1}')
    echo $os
}

# Get the Kernel version
get_kernel_version() {
    local kernel=$(uname -r)
    echo $kernel
}

# Get the CPU information
get_cpu_info() {
    local cpu=$(lscpu | awk '/Model name/ {print $3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18}')
    echo $cpu
}

# Get the memory usage, print using |vertical bar to print a diagram in the terminal
get_memory_usage() {
    local memory=$(free -h | awk '/Mem/ {print $3"/"$2}')
    
}

# Get battrey status, if the system is not a laptop, it will return "999%"
get_battery_usage() {
    local battery_file="/sys/class/power_supply/BAT1/capacity"
    if [[ -f $battery_file ]]; then
        local battery=$(cat $battery_file)
        echo $battery"%"
    else
        echo "999%"
    fi
}

# Get the disk usage
get_disk_usage() {
    local disk=$(df -h | awk '/\/$/ {print $3"/"$2}')
    echo $disk
}

