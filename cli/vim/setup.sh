backup_list() {
    local files_to_backup=(
        "$HOME/.vimrc"
        "$HOME/.vim"
    )
    printf "%s\n" "${files_to_backup[@]}"
}

pre_run() {
    local is_dry_run="$1"

    if [[ "$is_dry_run" == "true" ]]; then
        print_info "DRY RUN: Pre-run tasks"
    else
        print_info "Executing pre-run tasks"
        # Add any pre-run tasks here
    fi
}

post_run() {
    local is_dry_run="$1"

    if [[ "$is_dry_run" == "true" ]]; then
        print_info "DRY RUN: Post-run tasks"
        print_info "DRY RUN: Would install vim-plug plugin manager"
    else
        print_info "Executing post-run tasks"
        print_info "Installing vim-plug plugin manager"
        
        # Determine data directory (similar to vim's logic)
        local data_dir="$HOME/.vim"
        local autoload_dir="$data_dir/autoload"
        if [[ ! -d "$autoload_dir" ]]; then
            mkdir -p "$autoload_dir"
        fi
        
        # Check if vim-plug is already installed
        if [[ ! -f "$data_dir/autoload/plug.vim" ]]; then
            print_info "Downloading vim-plug to $data_dir/autoload/plug.vim"
            curl -fLo "$data_dir/autoload/plug.vim" --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            
            if [[ $? -eq 0 ]]; then
                print_info "vim-plug installed successfully"
            else
                print_error "Failed to install vim-plug"
                return 1
            fi
        else
            print_info "vim-plug is already installed"
        fi
    fi
}
