#!/bin/bash
sudo apt install -y git gcc gdb tmux zsh neofetch stow


chsh -s $(which zsh)

ZSH="$HOME/.dotfiles/oh-my-zsh" sh install.sh


list=(zsh git tmux vim)
for i in ${list[*]}; do
    stow -t $HOME $i || exit -1
done

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# 检查 zsh 是否安装
if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing Zsh..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt install -y zsh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install zsh
    fi
fi

# 安装 oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "oh-my-zsh already installed."
fi

# 安装 powerlevel10k
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "powerlevel10k already installed."
fi

# 设置 .zshrc 和 .p10k.zsh 的符号链接
DOTFILES_DIR="$HOME/dotfiles/zsh"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

echo "Zsh and powerlevel10k have been set up. Please restart your terminal."


