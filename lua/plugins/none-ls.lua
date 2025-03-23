-- lua/plugins/none-ls.lua
return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require "configs.none-ls"
  end,
}

