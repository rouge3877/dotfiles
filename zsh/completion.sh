# 启用补全系统
autoload -Uz compinit
compinit

# 历史记录设置
HISTFILE=~/.zsh_history     # 指定历史文件路径
HISTSIZE=100000             # 内存中保存的历史条目数
SAVEHIST=100000             # 历史文件中保存的最大条目数
setopt EXTENDED_HISTORY     # 记录时间戳和命令持续时间
setopt SHARE_HISTORY        # 多个会话共享历史记录
setopt HIST_IGNORE_ALL_DUPS # 忽略重复命令
setopt HIST_IGNORE_SPACE    # 忽略以空格开头的命令
setopt INC_APPEND_HISTORY   # 实时追加历史记录


# 补全样式设置
zstyle ':completion:*' menu select=2  # 启用菜单选择
zstyle ':completion:*' group-name ''  # 分组显示
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  # 使用LS_COLORS颜色

# 补全菜单配置
zmodload -i zsh/complist

# 高亮当前选中项
zstyle ':completion:*:*:*:*:default' menu yes select=2
zstyle ':completion:*' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'

# 键绑定配置
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab 反向导航
bindkey -M menuselect '^?' backward-delete-char     # 支持退格删除

# 增强补全显示
zstyle ':completion:*' format '%B%F{blue}-- %d --%f%b'  # 分组标题样式
zstyle ':completion:*' completer _expand _complete _match _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'     # 智能大小写匹配

# 补全优化配置
unsetopt LIST_AMBIGUOUS   # 不立即补全歧义项
setopt GLOB_COMPLETE      # 支持通配符补全
setopt MENU_COMPLETE      # 直接进入菜单选择
setopt AUTO_LIST          # 自动显示补全列表
setopt COMPLETE_IN_WORD   # 允许词中补全


# 启用历史建议功能
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end  # 上箭头
bindkey "^[[B" history-beginning-search-forward-end   # 下箭头
