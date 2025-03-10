# This is about oh-my-zsh

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Path to your Oh My Zsh installation.
export ZSH="$DOTFILES_ZSH/oh-my-zsh"
ZSH_CUSTOM=$DOTFILES_ZSH/omz-custom

# just remind me to update when it's time
zstyle ':omz:update' mode reminder


# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"


plugins=(

	git
	vi-mode
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	web-search
	emotty
)

source $ZSH/oh-my-zsh.sh


#################### Theme about oh-my-zsh ####################

ZSH_THEME="robbyrussell"

# 自定义提示符
PROMPT='%(?:%F{white}$:%F{red}$)%f '  # 正常状态绿色 >，错误状态红色 >
RPROMPT='$(git_prompt_info)'          # 右侧显示 Git 信息

# 配置 Git 提示格式
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}*%f"   # 有修改时显示红色 *
ZSH_THEME_GIT_PROMPT_CLEAN=""              # 无修改时不显示符号
ZSH_THEME_GIT_PROMPT_PREFIX="%F{blue}(%F{cyan}%b%F{red}@%h%F{blue})"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{green}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{yellow}↓"
