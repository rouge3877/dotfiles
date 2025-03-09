#!/bin/bash
: '
This script installs Vim and sets up a basic configuration.

Before running this script, following packages should be installed:
- vim
- curl
- git

It should be run on the root directory of the repository.
'


fetch-plug() {
    # First, judge if the directory exists
    PlugDir=~/.vim/pack/plugins/start
    if [ ! -d $PlugDir ]; then
        mkdir -p $PlugDir
    fi

    # Fetch plug from github with depth=1 (only the latest commit, for speed)
    git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim.git $PlugDir/ctrlp.vim

}

cp-vimrc() {
    # Copy the vimrc file to the home directory
    # First backup the original vimrc file (if exists)
    if [ ! -d ./backup ]; then
        mkdir ./backup
    fi

    if [ -f ~/.vimrc ]; then
        mv ~/.vimrc ./backup/.vimrc.bak
    fi

    ln -s $(pwd)/vim/vimrc ~/.vimrc
}

install-vim() {
    # Install vim
    sudo apt-get install vim
}

main() {
    cp-vimrc
    fetch-plug
}

main