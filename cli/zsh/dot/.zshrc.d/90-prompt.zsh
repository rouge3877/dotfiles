#######################################################
# ~/.zshrc.d/90-prompt.zsh - Zsh prompt configuration
# Author: Rouge Lin
# This is a part of my dotfiles

# This file stores all Zsh prompt settings (PROMPT, RPROMPT).
# If you use a prompt theme like Starship or Powerlevel10k,
#   the initialization code for that theme also goes here.
# It's recommended to keep prompt configuration at the end of your Zsh setup files.

# Example: PROMPT='%F{blue}%~%f %F{yellow}$%f '
#######################################################

# 配置并加载 Shell 提示符 (Prompt)
# Starship 是一个现代化的 Rust 编写的提示符
zinit light starship/starship

# 初始化 Starship
# 必须在最后，以确保它能获取到所有环境信息
eval "$(starship init zsh)"