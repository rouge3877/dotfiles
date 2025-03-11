#!/bin/bash
: '
This script is about Vim and sets up a basic configuration.
'

VIM_PLUGINS_LIST=(
    # github_url package_name vendor_name 
    # Use: [.vim/pack/$vendor_name/start/$package_name]
    "https://github.com/ctrlpvim/ctrlp.vim.git ctrlp.vim plugins"
    "https://github.com/preservim/nerdtree.git nerdtree vendor"
    "https://github.com/github/copilot.vim.git copilot.vim github"

)

VIM_PLUGINS_DIR=$DOTFILES/vim/pack
VIM_BACKUP_DIR=$DOTFILES_BACKUP/vim


_vim_install_plug() {

    if [ ! -d $VIM_PLUGINS_DIR ]; then
        mkdir -p $VIM_PLUGINS_DIR
    fi

    for plugin in "${VIM_PLUGINS_LIST[@]}"; do
        # install the plugin
        local github_url=$(echo $plugin | cut -d' ' -f1)
        local package_name=$(echo $plugin | cut -d' ' -f2)
        # vendor_name is optional, so we need to check if it exists
        if [ $(echo $plugin | wc -w) -eq 3 ]; then
            local vendor_name=$(echo $plugin | cut -d' ' -f3)
        else
            local vendor_name="plugins"
        fi

        echo "Installing $package_name..."

        local plugin_dir=$VIM_PLUGINS_DIR/$vendor_name/start/$package_name
        if [ ! -d $plugin_dir ]; then
            git clone --depth=1 $github_url $plugin_dir
        fi
    done

}

_vim_backup() {
    # backup the existing vim directory
    # check if backup directory exists
    echo "Backing up existing Vim configuration..."

    if [ ! -d $VIM_BACKUP_DIR ]; then
        mkdir -p $VIM_BACKUP_DIR
        echo "Created backup directory at $VIM_BACKUP_DIR"
    fi

    # if .vim as a symlink, remove it
    if [ -L $HOME/.vim ]; then
        rm $HOME/.vim
        echo "Removed existing symlink for .vim directory"
    fi
    # if .vimrc as a symlink, remove it
    if [ -L $HOME/.vimrc ]; then
        rm $HOME/.vimrc
        echo "Removed existing symlink for .vimrc"
    fi

    # check if .vim directory exists (mv with timestamp)
    if [ -d $HOME/.vim ]; then
        rm -rf $HOME/.vim
        echo "Moved .vim directory to $VIM_BACKUP_DIR/vim$(date +%Y%m%d%H%M%S)"
    fi
    # check if .vimrc exists
    if [ -f $HOME/.vimrc ]; then
        rm -rf $HOME/.vimrc
        echo "Moved .vimrc to $VIM_BACKUP_DIR/.vimrc$(date +%Y%m%d%H%M%S)"
    fi
}

_vim_make_symlinks() {
    # create symlinks
    ln -s $DOTFILES/vim $HOME/.vim
    echo "Created symlink: $HOME/.vim -> $DOTFILES/vim"
    ln -s $DOTFILES/vimrc $HOME/.vimrc
    echo "Created symlink: $HOME/.vimrc -> $DOTFILES/vimrc"
}

vim_install() {
    _vim_install_plug
    _vim_backup
    _vim_make_symlinks
}
