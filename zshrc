# This is config file for zsh
# Author: Rouge Lin

export DOTFILES=$HOME/dotfiles

export DOTFILES_ZSH=$DOTFILES/zsh
export DOTFILES_TMUX=$DOTFILES/tmux
export DOTFILES_VIM=$DOTFILES/vim
export DOTFILES_GIT=$DOTFILES/git
export DOTFILES_SSH=$DOTFILES/ssh

########### First source the essential config files #############

# source files function
source_files() {
  if [ -f $1 ]; then
    source $1
  else
    echo "File $1 not found"
  fi
}

# source all files in the directory
source_all_files() {
  for file in $1/*; do
    if [[ ${file: -3} == ".sh" ]]; then
      source_files $file
    fi
  done
}

############ Then, source all files in the directory ############
source_all_files $DOTFILES_ZSH

########### Finally, print info and open tmux smartly ###########
if [ -n "$TMUX" ]; then
elif [ -n "$(tmux list-sessions)" ]; then
  neofetch
  echo "There are tmux sessions running in background"
else
  # Create a new tmux session and open neofetch
  tmux new-session
  neofetch
fi

#################################################################





