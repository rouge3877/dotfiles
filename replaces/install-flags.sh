#!/usr/bin/env bash

# This script is used to install the flags for the project.
# ./flags/*-flags.conf -> ~/.config/*-flags.conf

create_link() {
    # Create a symbolic link to the file in the config directory
    ln -s "$(pwd)/$1" "$HOME/.config/$2"
    echo "Created link: $1 -> $2"
}

# Check if the script is run in the target directory (have install-flags.sh in the same directory)
if [ ! -f "install-flags.sh" ]; then
    echo "This script must be run in the same directory as install-flags.sh"
    exit 1
fi

# link the flags to the config directory
if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
fi

# link each flag file to the config directory
for file in flags/*-flags.conf; do

    filename=$(basename "$file" .conf)

    if [ -f "$HOME/.config/$filename.conf" ]; then
        echo "File $filename.conf already exists in $HOME/.config."
        read -p "Do you want to overwrite it? (y/n) " answer

        if [ "$answer" == "y" ]; then
            rm "$HOME/.config/$filename.conf"
            create_link "$file" "$filename.conf"
        else
            echo "Skipped $filename.conf."
        fi

    else
        create_link "$file" "$filename.conf"
    fi
done