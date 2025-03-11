#!/usr/bin/env bash

# This is the install script for my dotfiles
# There are three parts to this script:
#  - Set basic variables
#  - Install the dependencies
#  - Symlink the dotfiles

# Set basic variables
echo "Preparing to install dotfiles..."
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_SCRIPTS="$DOTFILES/SCRIPTS"
echo "Dotfiles directory: $DOTFILES"


# Install the dependencies
echo "Installing dependencies..."
source $DOTFILES_SCRIPTS/dependencies.sh

# Symlink the dotfiles
echo "Symlinking dotfiles..."
source $DOTFILES_SCRIPTS/symlink.sh

echo "Done!"
echo "Please restart your terminal to see the changes"
