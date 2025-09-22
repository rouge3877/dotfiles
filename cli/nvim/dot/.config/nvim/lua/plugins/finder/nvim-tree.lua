return {
    -- File explorer tree
    {
      'nvim-tree/nvim-tree.lua',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('nvim-tree').setup({})
        -- 在 keymaps.lua 中设置快捷键 <leader>e 来打开/关闭
      end,

      keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer in nvim-tree" }
      },

    },
}
