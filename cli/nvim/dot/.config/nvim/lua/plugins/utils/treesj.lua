return {

  -- splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc
  {
    "Wansmer/treesj",
    keys = { '<space>m', '<space>j', '<space>s' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    config = function()
      require('treesj').setup({--[[ your config ]]})
    end,
  },

}
