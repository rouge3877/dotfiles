#######################################################
# ~/.zshrc.d/20-aliases.zsh - Zsh aliases configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores all your personal command aliases (alias).
# Example: alias ll='ls -alF', alias g='git'
#######################################################

# Commonly used aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias ls='ls --color=auto'
alias ll='ls -lhaF'
alias l="ls --color=auto -l -a --human-readable"
alias grep='grep --color=auto'


# System related
alias clip="xclip -selection clipboard"
alias sl="sl -e"
alias pdf="google-chrome"


# Reload the config file
alias zshreload="source ~/.zshrc"


# python
alias venv="python3 -m venv .venv && source .venv/bin/activate"


# Open the current directory in the file manager
alias open="xdg-open ."


# about git
alias gmoji="gitmoji -c"


# about fzf
alias fzft="fzf --style full --preview 'less {}' --bind 'focus:transform-header:file --brief {}' --tmux --layout reverse --border top"


# safety first for file operations
alias mv='mv -i'
alias rm='echo "This is not the command you are looking for."; false'


# Kubernetes & Docker
alias k='kubectl'
alias d='docker'
alias dc='docker-compose'