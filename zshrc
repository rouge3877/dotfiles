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




########### 2. Print info and open tmux smartly ###########
if [ -n "$TMUX" ]; then
elif [ -n "$(tmux list-sessions)" ]; then
  echo "There are tmux sessions running in background"
  echo "Please attach to them"
else
  tmux new-session
fi

#################################################################


