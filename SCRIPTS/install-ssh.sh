#!/bin/bash
: '
This script is about ssh and sets up a basic configuration.
'

SSH_BACKUP_DIR=$DOTFILES_BACKUP/ssh


_ssh_backup_and_make_symlinks() {

    # Check if ssh directory exists
    if [ ! -d "~/.ssh" ]; then
        mkdir -p ~/.ssh
    fi

    echo "Backing up existing ssh configuration..."
    _backup_existing "$HOME/.ssh/config" "$SSH_BACKUP_DIR/config"

    # create symlinks
    _create_symlink "$DOTFILES/ssh/config" "$HOME/.ssh/config"
}

ssh_install() {
    _ssh_backup_and_make_symlinks
}
