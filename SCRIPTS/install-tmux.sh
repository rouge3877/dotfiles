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

_tmux_backup_and_make_symlinks() {
    echo "Backing up existing tmux configuration..."
    _backup_existing "$HOME/.tmux.conf" "$TMUX_BACKUP_DIR"
    _backup_existing "$HOME/.tmux" "$TMUX_BACKUP_DIR"

    # create symlinks
    _create_symlink "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
    _create_symlink "$DOTFILES/tmux" "$HOME/.tmux"
}

tmux_install() {
    _tmux_install_plug
    _tmux_backup_and_make_symlinks
}
