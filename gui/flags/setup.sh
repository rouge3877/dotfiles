backup_list() {
    local files_to_backup=(
        "$HOME/.config/chrome-flags.conf"
        "$HOME/.config/code-flags.conf"
        "$HOME/.config/qq-flags.conf"
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
    else
        print_info "Executing post-run tasks"
        # Add any post-run tasks here
    fi
}
