#######################################################
# ~/.zshrc - ZSH configuration file
# Author: Rouge Lin
# This is a part of my dotfiles

# This file is sourced for interactive shells.
#######################################################


########### 1. Source the essential config files ###########

ZSHRC_DIR=${DOTFILES_ZSH:-$HOME}/.zshrc.d

# Check if the directory exists and then source all .zsh files within it.
# The numeric prefixes on the filenames will control the loading order.
if [ -d "$ZSHRC_DIR" ]; then
  for config_file in "$ZSHRC_DIR"/*.zsh; do
    source "$config_file"
  done
  # Unset the variable to keep the environment clean
  unset config_file
fi

unset ZSHRC_DIR


########### 2. Quick fixes ###########

# Disable terminal bell
set bell-style none # for readline-compatible programs
bind 'set bell-style none' 2>/dev/null || true
setopt no_beep # Disable all Zsh beeps



