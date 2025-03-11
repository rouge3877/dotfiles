#!/bin/bash
: '
This script is about ssh and sets up a basic configuration.
'

SSH_BACKUP_DIR=$DOTFILES_BACKUP/ssh


_ssh_backup_and_make_symlinks() {
    echo "Backing up existing ssh configuration..."
    _backup_existing "$HOME/.ssh" "$SSH_BACKUP_DIR"

    # create symlinks
    _create_symlink "$DOTFILES/ssh" "$HOME/.ssh"
}

ssh_install() {
    _ssh_backup_and_make_symlinks
}
