#!/usr/bin/env bash

# This is the install script for my dotfiles
# There are three parts to this script:
#  - Set basic variables
#  - Install the dependencies
#  - Symlink the dotfiles

# Set basic variables
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Dotfiles directory: $DOTFILES"

DOTFILES_SCRIPTS="$DOTFILES/SCRIPTS"

# Install the dependencies
echo "Installing dependencies..."
source $DOTFILES_SCRIPTS/dependencies.list.sh
source $DOTFILES_SCRIPTS/dependencies.sh
