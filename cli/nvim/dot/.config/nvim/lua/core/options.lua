-- [[ 设置 Neovim 选项 ]]
-- 参考 :help options

-- leader 键是自定义快捷键的前缀，空格键是最好的选择
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 使用 utf-8 编码
vim.opt.encoding = 'utf-8'

-- 让 vim 显示行号
vim.opt.number = true
vim.opt.relativenumber = true -- 相对行号

-- 启用 24-bit RGB 颜色，让主题色彩更丰富
vim.opt.termguicolors = true

-- 缩进设置
vim.opt.tabstop = 4         -- Tab 宽度为4个空格
vim.opt.shiftwidth = 4      -- 自动缩进宽度为4个空格
vim.opt.expandtab = true    -- 将 Tab 转换为空格
vim.opt.autoindent = true   -- 自动缩进

-- 搜索设置
vim.opt.ignorecase = true   -- 搜索时忽略大小写
vim.opt.smartcase = true    -- 如果搜索模式包含大写字母，则不忽略大小写

-- 外观
vim.opt.cursorline = true   -- 高亮当前行
vim.opt.signcolumn = 'yes'  -- 始终显示符号列，以避免UI抖动

-- 禁用换行
vim.opt.wrap = false

-- 启用鼠标
vim.opt.mouse = 'a'

-- 分屏设置
vim.opt.splitright = true   -- 新的垂直分屏出现在右边
vim.opt.splitbelow = true   -- 新的水平分屏出现在下边
