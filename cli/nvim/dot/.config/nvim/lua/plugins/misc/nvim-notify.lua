return {
  -- local plugins can also be configured with the dev option.
  -- This will use {config.dev.path}/noice.nvim/ instead of fetching it from GitHub
  -- With the dev option, you can easily switch between the local and installed version of a plugin
  -- { "folke/noice.nvim", dev = true },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end
    },
}