#!/bin/bash
: '
This script is about tmux and sets up a basic configuration.
'

TMUX_PLUGINS_LIST=(
    # github_url package_name vendor_name 

)

TMUX_PLUGINS_DIR=$DOTFILES/tmux/plugins
TMUX_BACKUP_DIR=$DOTFILES_BACKUP/tmux


_tmux_install_plug() {

    if [ ! -d $TMUX_PLUGINS_DIR ]; then
        mkdir -p $TMUX_PLUGINS_DIR
    fi

    # for plugin in "${TMUX_PLUGINS_LIST[@]}"; do
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

    #     local plugin_dir=$TMUX_PLUGINS_DIR/$vendor_name/start/$package_name
    #     if [ ! -d $plugin_dir ]; then
    #         git clone --depth=1 $github_url $plugin_dir
    #     fi
    # done

}

_tmux_backup() {
    # backup the existing tmux directory
    # check if backup directory exists
    echo "Backing up existing Vim configuration..."

    if [ ! -d $TMUX_BACKUP_DIR ]; then
        mkdir -p $TMUX_BACKUP_DIR
        echo "Created backup directory at $TMUX_BACKUP_DIR"
    fi

    # if .tmux as a symlink, remove it
    if [ -L $HOME/.tmux ]; then
        rm $HOME/.tmux
        echo "Removed existing symlink for .tmux directory"
    fi
    # if .tmux.conf as a symlink, remove it
    if [ -L $HOME/.tmux.conf ]; then
        rm $HOME/.tmux.conf
        echo "Removed existing symlink for .tmux.conf"
    fi

    # check if .tmux directory exists (mv with timestamp)
    if [ -d $HOME/.tmux ]; then
        # rm -rf $HOME/.tmux
        mv $HOME/.tmux $TMUX_BACKUP_DIR/tmux$(date +%Y%m%d%H%M%S)
        echo "Moved .tmux directory to $TMUX_BACKUP_DIR/tmux$(date +%Y%m%d%H%M%S)"
    fi
    # check if .tmux.conf exists
    if [ -f $HOME/.tmux.conf ]; then
        # rm -rf $HOME/.tmux.conf
        mv $HOME/.tmux.conf $TMUX_BACKUP_DIR/.tmux.conf$(date +%Y%m%d%H%M%S)
        echo "Moved .tmux.conf to $TMUX_BACKUP_DIR/.tmux.conf$(date +%Y%m%d%H%M%S)"
    fi
}

_tmux_make_symlinks() {
    # create symlinks
    ln -s $DOTFILES/tmux $HOME/.tmux
    echo "Created symlink: $HOME/.tmux -> $DOTFILES/tmux"
    ln -s $DOTFILES/tmux.conf $HOME/.tmux.conf
    echo "Created symlink: $HOME/.tmux.conf -> $DOTFILES/tmux.conf"
}

tmux_install() {
    _tmux_install_plug
    _tmux_backup
    _tmux_make_symlinks
}
