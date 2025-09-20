-- [[ 设置快捷键 ]]

-- 设置快捷键的函数，简化后续编写
local map = vim.keymap.set

-- Normal 模式

-- 窗口管理
map('n', '<leader>sv', '<C-w>v', { desc = '垂直分屏' })
map('n', '<leader>sh', '<C-w>s', { desc = '水平分屏' })
map('n', '<leader>se', '<C-w>=', { desc = '等宽分屏' })
map('n', '<leader>sx', '<cmd>close<CR>', { desc = '关闭当前分屏' })

-- 标签页管理
map('n', '<leader>to', '<cmd>tabnew<CR>', { desc = '打开新标签页' })
map('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = '关闭当前标签页' })
map('n', '<leader>tn', '<cmd>tabn<CR>', { desc = '切换到下一个标签页' })
map('n', '<leader>tp', '<cmd>tabp<CR>', { desc = '切换到上一个标签页' })

-- Visual 模式

-- 上下移动选中的代码块
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = "向下移动选中行" })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = "向上移动选中行" })

