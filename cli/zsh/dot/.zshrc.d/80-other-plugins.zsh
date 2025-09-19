#######################################################
# ~/.zshrc.d/80-other-plugins.zsh - Zsh UI and syntax plugins conf
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores loading UI, theme, and syntax-related zsh plugins.

# Syntax highlighting plugins (e.g., zsh-users/zsh-syntax-highlighting)
#   must be loaded last because they need to parse the entire command line.
# They need to see all commands, aliases, and functions to highlight correctly.
# If loaded too early, they might miss some definitions and highlight incorrectly.

# Auto-suggestion/completion plugins (e.g., zsh-users/zsh-autosuggestions)
#   should also be loaded late to have access to the full set of commands
#   and functions defined in the shell environment.

# Theme and prompt plugins (e.g., romkatv/powerlevel10k, starship)
#   often depend on various commands and environment variables.
# Loading them last ensures they can access everything they need to display
#   the prompt correctly.

# Example: zsh-users/zsh-syntax-highlighting
#######################################################

# Plugin setting for zsh-users/zsh-history-substring-search
# Let the history substring search results be unique
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Substring history search
# use up/down to navigate through history
zinit light zsh-users/zsh-history-substring-search

# Commands you type will be auto-suggested based on your history
# gray text, use right-arrow to accept
zinit light zsh-users/zsh-autosuggestions

# Additional completion definitions
#   Provides many more completion definitions for various commands
zinit light zsh-users/zsh-completions

# Enhanced tab completion with preview
# Use arrow keys to navigate, Tab to complete
# Requires: fzf
zinit light Aloxaf/fzf-tab

# Syntax highlighting
# This must be loaded last to correctly parse the entire command line
# So that it can recognize all aliases and functions
zinit light zsh-users/zsh-syntax-highlighting