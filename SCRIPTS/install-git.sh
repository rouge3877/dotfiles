#!/bin/bash
: '
This script is about git and sets up a basic configuration.
'

GIT_BACKUP_DIR=$DOTFILES_BACKUP/git

_git_backup_and_make_symlinks() {
    echo "Backing up existing git configuration..."
    _backup_existing "$HOME/.gitconfig" "$GIT_BACKUP_DIR"

    # create symlinks
    _create_symlink "$DOTFILES/gitconfig" "$HOME/.gitconfig"
}

git_install() {
    _git_backup_and_make_symlinks
}
