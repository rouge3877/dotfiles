#!/bin/bash
: '
This script is about backup and create symlinks
'

# 通用备份函数
# 参数: $1 - 需要备份的目标路径
#       $2 - 备份存储目录
_backup_existing() {
    local target_path=$1
    local backup_dir=$2
    
    # 如果目标路径不存在则直接返回
    [ ! -e "$target_path" ] && return

    echo "Backing up $target_path..."

    # 确保备份目录存在
    mkdir -p "$backup_dir" || return 1

    # 处理符号链接
    if [ -L "$target_path" ]; then
        rm "$target_path"
        echo "Removed existing symlink: $target_path"
        return
    fi

    # 生成带时间戳的备份文件名
    local backup_name
    backup_name="$(basename "$target_path")_$(date +%Y%m%d%H%M%S)"
    
    # 移动原始文件/目录到备份目录
    if [ -d "$target_path" ] || [ -f "$target_path" ]; then
        mv "$target_path" "$backup_dir/$backup_name"
        echo "Moved original to: $backup_dir/$backup_name"
    fi
}

# 通用符号链接创建函数
# 参数: $1 - 源路径 (实际文件)
#       $2 - 目标路径 (符号链接路径)
_create_symlink() {
    ln -s "$1" "$2" && echo "Created symlink: $2 -> $1"
}
