#######################################################
# ~/.zprofile - Zsh profile configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file is sourced for login shells, like ~/.bash_profile.
# It is a good place to put commands that should run only once at the start of a session.
#######################################################

# Start ssh-agent (if not already running)
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#   ssh-agent > "$HOME/.ssh/agent.env"
# fi
# source "$HOME/.ssh/agent.env"

# Display a welcome message
echo "Welcome back, $(whoami)!"

# neofetch (only show in non-GUI environments to avoid clutter)
if [ -x "$(command -v neofetch)" ] && [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  neofetch
fi

# Start Hyprland GUI (only if not already running and in TTY)
# if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
#   if command -v hyprland >/dev/null 2>&1; then
#     echo "Starting Hyprland..."
#     exec hyprland
#   fi
# fi