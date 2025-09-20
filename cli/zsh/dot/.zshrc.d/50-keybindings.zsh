#######################################################
# ~/.zshrc.d/50-keybindings.zsh - Zsh keybindings configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores all Zsh keybindings (bindkey) settings.

# Example: bindkey '^[[A' history-substring-search-up
#######################################################


# Vim Mode
bindkey -v

# alt + l to accept autosuggestion
bindkey '^[l' autosuggest-accept

# alt + j/k to navigate through history
bindkey '^[j' history-substring-search-down
bindkey '^[k' history-substring-search-up

