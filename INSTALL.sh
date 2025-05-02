#!/usr/bin/env bash

# This is the install script for my dotfiles
# There are three parts to this script:
#  - Set basic variables
#  - Install the dependencies
#  - Symlink the dotfiles

# 1. Set basic variables
echo "Preparing to install dotfiles..."
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_SCRIPTS="$DOTFILES/SCRIPTS"
echo "Dotfiles directory: $DOTFILES"
source $DOTFILES_SCRIPTS/utilities.sh

# everytime, create a backup folder with timestamp
mkdir -p $DOTFILES/.backup/$(date +%Y%m%d%H%M%S)
DOTFILES_BACKUP=$DOTFILES/.backup/$(date +%Y%m%d%H%M%S)


# 2. Install the dependencies
echo "Installing dependencies..."
cd $DOTFILES_SCRIPTS
./dependencies.sh ./pkg_list.json

# 3. Symlink the dotfiles

set_list=(
    zsh
    vim
    tmux
    ssh
    git
)

echo "=== Symlinking dotfiles ==="
for type in "${set_list[@]}"; do
    echo "Symlinking $type..."
    source $DOTFILES_SCRIPTS/install-$type.sh
    ${type}_install
done

# 4. stow the config/ to ~/.config
echo "=== Stowing config ==="
# stow -t $HOME/.config $DOTFILES/config
cd $DOTFILES/config
for dir in */; do
    target_dir="$HOME/.config/${dir%/}"
    source_dir="$PWD/${dir%/}"

    if [ -e "$target_dir" ]; then
        echo "backup exist dir: $target_dir -> ${DOTFILES_BACKUP}/${dir%/}.bak"
        mv "$target_dir" "${DOTFILES_BACKUP}/${dir%/}.bak"
    fi

    ln -svf "$source_dir" "$target_dir"
done


echo "Done!"
echo "All the old dotfiles are backed up in $DOTFILES_BACKUP"
echo "Have fun with your new dotfiles!"
