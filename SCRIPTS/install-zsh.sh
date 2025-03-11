#!/bin/bash
: '
This script is about zsh and sets up a basic configuration.
'

ZSH_BACKUP_DIR=$DOTFILES_BACKUP/zsh


_zsh_backup() {
    # backup the existing zsh directory
    # check if backup directory exists
    echo "Backing up existing zsh configuration..."

    if [ ! -d $ZSH_BACKUP_DIR ]; then
        mkdir -p $ZSH_BACKUP_DIR
        echo "Created backup directory at $ZSH_BACKUP_DIR"
    fi
    fi
    # if .zshrc as a symlink, remove it
    if [ -L $HOME/.zshrc ]; then
        rm $HOME/.zshrc
        echo "Removed existing symlink for .zshrc"
    fi
    # check if .zshrc exists
    if [ -f $HOME/.zshrc ]; then
        rm -rf $HOME/.zshrc
        echo "Moved .zshrc to $ZSH_BACKUP_DIR/.zshrc$(date +%Y%m%d%H%M%S)"
    fi
}

_zsh_make_symlinks() {
    # create symlinks
    ln -s $DOTFILES/zshrc $HOME/.zshrc
    echo "Created symlink: $HOME/.zshrc -> $DOTFILES/zshrc"
}

zsh_install() {
    _zsh_backup
    _zsh_make_symlinks
}
