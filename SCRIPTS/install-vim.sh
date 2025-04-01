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
    "https://github.com/roxma/vim-tmux-clipboard.git vim-tmux-clipboard plugins"
)

VIM_BACKUP_DIR=$DOTFILES_BACKUP/vim

_vim_install_plug() {
    # install vim-plug
    local PLUG_INSTALL_PATH=$DOTFILES/vim/autoload/plug.vim
    local PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    if [ ! -f $PLUG_INSTALL_PATH ]; then
        echo "Installing vim-plug..."
        curl -fLo $PLUG_INSTALL_PATH --create-dirs $PLUG_URL
    fi

    # VIM_PLUGINS_DIR=$DOTFILES/vim/pack

    # if [ ! -d $VIM_PLUGINS_DIR ]; then
    #     mkdir -p $VIM_PLUGINS_DIR
    # fi

    # for plugin in "${VIM_PLUGINS_LIST[@]}"; do
    #     # install the plugin
    #     local github_url=$(echo $plugin | cut -d' ' -f1)
    #     local package_name=$(echo $plugin | cut -d' ' -f2)
    #     # vendor_name is optional, so we need to check if it exists
    #     if [ $(echo $plugin | wc -w) -eq 3 ]; then
    #         local vendor_name=$(echo $plugin | cut -d' ' -f3)
    #     else
    #         local vendor_name="plugins"
    #     fi

    #     echo "Installing $package_name..."

    #     local plugin_dir=$VIM_PLUGINS_DIR/$vendor_name/start/$package_name
    #     if [ ! -d $plugin_dir ]; then
    #         git clone --depth=1 $github_url $plugin_dir
    #     fi
    # done
}

_vim_backup_and_make_symlinks() {
    # backup the existing vim directory
    echo "Backing up existing Vim configuration..."
    _backup_existing "$HOME/.vim" "$VIM_BACKUP_DIR"
    _backup_existing "$HOME/.vimrc" "$VIM_BACKUP_DIR"    

    # create symlinks
    _create_symlink "$DOTFILES/vim" "$HOME/.vim"
    _create_symlink "$DOTFILES/vimrc" "$HOME/.vimrc"
}


vim_install() {
    _vim_install_plug
    _vim_backup_and_make_symlinks
}
