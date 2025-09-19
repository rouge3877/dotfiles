#######################################################
# ~/.zshrc.d/05-completion.zsh - Zsh completion configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores all Zsh compinit settings.
#######################################################

# ensure compinit is loaded
autoload -Uz compinit
if [ -n "$HOME/.zcompdump" ]; then
    compinit -i -d "$HOME/.zcompdump"
else
    compinit
fi


# Completion matching strategies
# define the order of completers
zstyle ':completion:*' completer _expand _complete _match _approximate
# case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# Set styles for fzf-tab
# zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls -l $word'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
