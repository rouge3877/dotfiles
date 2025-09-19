backup_list() {
    local files_to_backup=(
        "$HOME/.ssh"
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
        echo "Created SSH multiplexing sockets directory: $sockets_dir"
    else
        print_info "Executing post-run tasks"
        local sockets_dir="$HOME/.ssh/sockets"
        if mkdir -p "$sockets_dir"; then
            echo "Created SSH multiplexing sockets directory: $sockets_dir"
        else
            echo "Warning: Failed to create SSH sockets directory: $sockets_dir"
        fi
    fi
}
