return {

  -- 
  {
    "nvim-neorg/neorg",
    -- lazy-load on filetype
    ft = "norg",
    -- options for neorg. This will automatically call `require("neorg").setup(opts)`

    lazy = false,
    -- While lazy supports lazy-loading upon specific commands and filetypes,
    -- it can cause neorg to load incorrectly, leading to a 'broken' plugin

    version = "*", -- Pin Neorg to the latest stable release
    config = true,

    opts = {
      load = {
        ["core.defaults"] = {},
      },
    },
  },

}
