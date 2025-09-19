#!/bin/bash

# --- Configuration ---
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[1;33m';
BLUE='\033[0;34m';
NC='\033[0m';

DOTFILE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$DOTFILE_ROOT/cli"
GUI_DIR="$DOTFILE_ROOT/gui"

BACKUP_TARGET_DIR="$DOTFILE_ROOT/.backup"
if [ ! -d "$BACKUP_TARGET_DIR" ]; then
    mkdir -p "$BACKUP_TARGET_DIR"
    echo "Created target directory: $BACKUP_TARGET_DIR"
fi
# Add time stamp to backup directory to avoid overwriting previous backups
BACKUP_TARGET_DIR="$BACKUP_TARGET_DIR/$(date +%Y%m%d_%H%M%S)"
if [ ! -d "$BACKUP_TARGET_DIR" ]; then
    mkdir -p "$BACKUP_TARGET_DIR"
    echo "Created timestamped backup directory: $BACKUP_TARGET_DIR"
fi

# --- source all helper functions ---
# --- Helper Functions ---
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }


# --- Core Functions ---
# Function to setup a single module (e.g., 'cli/tmux', 'gui/kitty')
setup_package() {
    local module_name="$1"
    local dry_run="$2"
    
    local module_path="$DOTFILE_ROOT/$module_name"
    if [[ ! -d "$module_path" ]]; then
        print_warning "Module '$module_name' not found at '$module_path', skipping."
        return 1
    fi
    
    # each module can have its own setup.sh for custom pre-processing
    # it provides three functions:
    #   - backup_list (returns array of files/directories to backup)
    #   - pre_run (is_dry_run)
    #   - post_run (is_dry_run)
    local setup_script="$module_path/setup.sh"
    source "$setup_script"
    
    
    # Call the backup_list function if it exists
    if declare -f "backup_list" > /dev/null; then
        print_info "Running backup_list for module '$module_name'"
        local files_to_backup
        IFS=$'\n' read -d '' -r -a files_to_backup < <(backup_list)
        if [[ ${#files_to_backup[@]} -eq 0 ]]; then
            print_warning "No files to backup for module '$module_name'."
        else
            print_info "Files to backup for module '$module_name':"
            for file in "${files_to_backup[@]}"; do
                print_info " - $file"
                if [[ "$dry_run" == "true" ]]; then
                    print_info "DRY RUN: Would back up '$file' -> '$BACKUP_TARGET_DIR'"
                else
                    if [[ -e "$file" ]]; then # -e checks if file exists (file or dir)
                        \mv "$file" "$BACKUP_TARGET_DIR/"
                        if [[ $? -eq 0 ]]; then
                            print_success "Backed up '$file' -> '$BACKUP_TARGET_DIR/'"
                        else
                            print_error "Failed to back up '$file' -> '$BACKUP_TARGET_DIR/'"
                        fi
                    else
                        print_warning "File '$file' does not exist, skipping backup."
                    fi
                fi
            done
        fi
    fi
    
    # Call the pre_run function if it exists
    if declare -f "pre_run" > /dev/null; then
        print_info "Running pre-run for module '$module_name'"
        if ! pre_run "$dry_run"; then
            print_error "Pre-run failed for module '$module_name'."
            return 1
        fi
    fi
    
    # 2. Use stow to create the symlinks
    print_info "Stowing dotfiles for module: $module_name"
    
    local dry_run_flag=""
    if [[ "$dry_run" == "true" ]]; then
        dry_run_flag="--simulate"
        # In dry-run mode, we need to use --adopt to handle remaining conflicts
        # or use a different approach since files weren't actually moved
        print_info "Dry-run: Would stow dotfiles for module '$module_name'"
        if stow -v --simulate --dir="$module_path" --target="$HOME" --adopt dot 2>/dev/null; then
            print_success "Module '$module_name' would be processed successfully."
        else
            print_warning "Module '$module_name' has conflicts that would be resolved by backup and stow."
        fi
    else
        # In real mode, files should have been backed up, so stow should work
        if stow -v -R --dir="$module_path" --target="$HOME" dot; then
            print_success "Module '$module_name' processed successfully."
        else
            print_error "Failed to stow dotfiles for module '$module_name'."
            return 1
        fi
    fi
    
    # Call the post_run function if it exists
    if declare -f "post_run" > /dev/null; then
        print_info "Running post-run for module '$module_name'"
        if ! post_run "$dry_run"; then
            print_error "Post-run failed for module '$module_name'."
            return 1
        fi
    fi
    
    echo
}

# --- Main Logic ---
main() {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then show_usage; exit 0; fi
    if ! command -v stow &> /dev/null; then print_error "stow could not be found."; exit 1; fi
    
    local dry_run=false
    local packages_to_setup=()
    
    for arg in "$@"; do
        if [[ "$arg" == "-n" || "$arg" == "--dry-run" ]]; then
            dry_run=true
        else
            packages_to_setup+=("$arg")
        fi
    done
    
    if [[ "$dry_run" == "true" ]]; then print_info "DRY RUN MODE - No changes will be made."; fi
    
    if [ ${#packages_to_setup[@]} -eq 0 ]; then
        print_info "Setting up all modules ..."
        
        cli_list=( $(find "$CLI_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;) )
        gui_list=( $(find "$GUI_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;) )
        for i in "${!cli_list[@]}"; do cli_list[i]="cli/${cli_list[i]}"; done
        for i in "${!gui_list[@]}"; do gui_list[i]="gui/${gui_list[i]}"; done
        
        packages_to_setup+=( "${cli_list[@]}" )
        packages_to_setup+=( "${gui_list[@]}" )
        
    fi
    
    print_info "Target modules: ${packages_to_setup[*]}"
    echo
    
    local error_count=0
    local error_list=()
    for pkg in "${packages_to_setup[@]}"; do

        if ! setup_package "$pkg" "$dry_run"; then
            ((error_count++))
            error_list+=("$pkg")
        fi
    done
    
    print_info "Setup completed!"
    if [[ $error_count -gt 0 ]]; then
        print_error "$error_count module(s) failed to process:";
        for err in "${error_list[@]}"; do
            print_error " - $err"
        done
        exit 1;
    fi
}

show_usage() {
    echo "Usage: $0 [OPTIONS] [MODULE_NAME...]"
    echo
    echo "Options:"
    echo "  -n, --dry-run       Preview actions without making changes"
    echo "  -h, --help          Show this help message and exit"
    echo "If no MODULE_NAME is provided, all modules in '$CLI_DIR' will be processed."
    echo "Example: $0 tmux zsh"
    echo "Example (dry run): $0 --dry-run tmux"
    echo "Example (all modules): $0"
    echo "Example (dry run all modules): $0 --dry-run"
}

main "$@"

