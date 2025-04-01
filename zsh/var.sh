# This is about the vars of Zsh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi


# Check if the .zshenv file exists
if [ -f ~/.zshenv ]; then
  # Source the .zshenv file
else
  echo "no ~/.zshenv"
fi
