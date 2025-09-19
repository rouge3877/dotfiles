#######################################################
# ~/.profile - Bash profile configuration file
# Author: Rouge Lin
# This is a part of my dotfiles

# This file is sourced for login shells.
#######################################################

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

echo "Welcome, $USER! You are logged in on $(hostname) at $(date)."
echo "Your shell is bash now."