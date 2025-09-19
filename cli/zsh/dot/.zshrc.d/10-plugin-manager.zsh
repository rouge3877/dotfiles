#######################################################
# ~/.zshrc.d/10-plugin-manager.zsh - Zsh plugins manager conf
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores loading zsh plugin manager (e.g., zinit, zplug, antigen, zgen).

# Manager like zinit, zgen, antigen must be sourced before loading any plugins.
# That's why this file should be named with a number (10) lower than other files.

#######################################################

# Load Zinit plugin manager
# If Zinit is not installed, this script will automatically download it
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth"1" # git clone depth=1 for faster installs
