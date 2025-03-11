#!/bin/bash
: '
This script is about zsh and sets up a basic configuration.
'

ZSH_BACKUP_DIR=$DOTFILES_BACKUP/zsh


_zsh_backup_and_make_symlinks() {
    # backup the existing zsh directory
    echo "Backing up existing zsh configuration..."
    _backup_existing "$HOME/.zshrc" "$ZSH_BACKUP_DIR"

    # create symlinks
    _create_symlink "$DOTFILES/zshrc" "$HOME/.zshrc"
}

zsh_install() {
    _zsh_backup_and_make_symlinks
}
