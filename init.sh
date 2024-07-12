sudo apt install gcc gdb tmux zsh neofetch stow

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

chsh -s $(which zsh)

ZSH="$HOME/.dotfiles/oh-my-zsh" sh install.sh


list=(zsh git tmux nvim )
for i in ${list[*]}; do
    stow -t $HOME $i || exit -1
done

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

cd ~/dotfiles/tmux/.tmux
git clone https://github.com/gpakosz/.tmux.git
