#######################################################
# ~/.zshrc.d/01-options.zsh - Zsh options configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores all Zsh option settings (setopt, unsetopt).
# These are fundamental behaviors of Zsh and should be loaded first.

# Example: setopt auto_cd, setopt hist_ignore_dups
#######################################################

# 允许在提示符中进行变量替换
setopt PROMPT_SUBST

# 历史记录设置
HISTFILE=~/.zsh_history     # 指定历史文件路径
HISTSIZE=100000             # 内存中保存的历史条目数
SAVEHIST=100000             # 历史文件中保存的最大条目数
setopt EXTENDED_HISTORY     # 记录时间戳和命令持续时间
setopt SHARE_HISTORY        # 多个会话共享历史记录
setopt HIST_IGNORE_ALL_DUPS # 忽略重复命令
setopt HIST_IGNORE_SPACE    # 忽略以空格开头的命令
setopt INC_APPEND_HISTORY   # 实时追加历史记录

# --- 导航 ---
setopt auto_cd             # 如果输入的是目录名，直接进入
setopt auto_pushd          # 自动将 `cd` 的目录加入栈中，方便用 `dirs`
setopt pushd_ignore_dups   # 不要将重复的目录压入栈

# --- 补全 ---
setopt MENU_COMPLETE      # 强烈推荐! 直接进入菜单选择模式，比 AUTO_LIST 更好用
setopt GLOB_COMPLETE      # 支持通配符补全
setopt complete_in_word    # 允许从单词中间开始补全
zstyle ':completion:*' menu select # 开启 TAB 菜单补全

# --- 其他 ---
setopt extended_glob       # 开启更强大的文件匹配功能
unsetopt BEEP               # 关闭错误提示音

# 加载 Zsh 的版本控制信息模块
autoload -U vcs_info
zstyle ':vcs_info:*' enable git # 只启用 git
