#######################################################
# ~/.zshenv - Zsh environment configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file is sourced for all Zsh sessions, including non-interactive ones.
# So, this file should be very small and clean,
#     containing only variables that must exist regardless of interactivity.
#######################################################

# Basic environment settings
export EDITOR='vim'
export VISUAL="$EDITOR"
export LANG='en_US.UTF-8'
export TERM='xterm-256color'



# Set 'less' as the default pager with options:
# -R: Allow raw control characters (for color support)
# -F: Automatically exit if the content fits on one screen
export PAGER='less'
export LESS='-RF'


# Set XDG base directories (modern Linux application standard)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"


# Variable to locate your dotfiles
export DOTFILES="$HOME/.dotfiles"

export DOTFILES_ZSH=$DOTFILES/cli/zsh/dot
export DOTFILES_VIM=$DOTFILES/cli/vim/dot
export DOTFILES_GIT=$DOTFILES/cli/git/dot
export DOTFILES_SSH=$DOTFILES/cli/ssh/dot
export DOTFILES_NPM=$DOTFILES/cli/npm/dot
export DOTFILES_BASH=$DOTFILES/cli/bash/dot
export DOTFILES_TMUX=$DOTFILES/cli/tmux/dot


# Add user's private bin to PATH
export PATH="$HOME/.local/bin:$PATH"


# --- Load machine-specific settings if they exist ---
if [ -f ~/.zshenv.local ]; then
    source ~/.zshenv.local
fi
