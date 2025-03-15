# This is about the fzf config of Zsh

alias fzft="fzf --style full --preview 'less {}' --bind 'focus:transform-header:file --brief {}' --tmux --layout reverse --border top"


# A function that can specify the directory to search
fzfdir () {
    local dir="$1"
    if [ -z "$dir" ]; then
        dir="."
    fi

    find "$dir" -type f | fzf --preview 'less {}' --bind 'focus:transform-header:file --brief {}' --tmux --layout reverse --border top
}

