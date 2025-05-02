# This is config file for zsh
# Author: Rouge Lin

export DOTFILES=$HOME/dotfiles

export DOTFILES_ZSH=$DOTFILES/zsh
export DOTFILES_TMUX=$DOTFILES/tmux
export DOTFILES_VIM=$DOTFILES/vim
export DOTFILES_GIT=$DOTFILES/git
export DOTFILES_SSH=$DOTFILES/ssh

########### 1. Source the essential config files #############

# source_files() {
#   if [ -f $1 ]; then
#     source $1
#   else
#     echo "File $1 not found"
#   fi
# }
# source_all_files() {
#   for file in $1/*; do
#     if [[ ${file: -3} == ".sh" ]]; then
#       source_files $file
#     fi
#   done
# }
# source_all_files $DOTFILES_ZSH

for file in $DOTFILES_ZSH/*; do
  if [[ ${file: -3} == ".sh" ]]; then
    if [ -f $file ]; then
      source $file
    else
      echo "File $file not found"
    fi
  fi
done


########### 2. Set zinit for zsh plugins ###########

# proxy_on
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light fdellwing/zsh-bat
zinit light agkozak/zsh-z
# proxy_off
autoload -U compinit; compinit


########### 3. Print info and open tmux smartly ###########
# if [ -n "$TMUX" ]; then
# elif [ -n "$(tmux list-sessions)" ]; then
#   echo "There are tmux sessions running in background"
#   echo "Please attach to them"
# else
#   tmux new-session
# fi

# 禁用BELL
set bell-style none       # 适用于Bash
bind 'set bell-style none' 2>/dev/null || true
setopt no_beep           # 禁用所有Zsh的蜂鸣

#################################################################


