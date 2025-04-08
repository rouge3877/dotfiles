# 启用prompt替换功能
setopt PROMPT_SUBST

# 定义颜色常量（兼容不同终端）
local color_info="%F{green}"
local color_branch="%F{blue}"
local color_hash="%F{yellow}"
local color_dirty="%F{red}"
local color_remote="%F{magenta}"
local color_reset="%f"

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

# 综合Git信息显示
function get_git_prompt() {
    is_inside_git_repo || return
    
    local info=""
    info+="${color_branch}$(get_git_branch)${color_reset}"
    info+="${color_hash}@$(git rev-parse --short HEAD 2>/dev/null)${color_reset}"
    info+="${color_dirty}$(get_git_status)${color_reset}"
    info+="${color_remote}$(get_remote_status)${color_reset}"
    
    echo "[${info}]"
}

# 设置prompt
PROMPT='%# '  # 显示$或#
# RPROMPT='$(get_git_prompt)'
