-- lua/plugins/notify.lua
return {
  "rcarriga/nvim-notify",
  -- This is the missing line. It tells lazy.nvim to load this plugin
  -- as soon as startup is complete and the UI is ready.
  event = "VeryLazy",
  config = function()
    vim.notify = require "notify"
  end,
}
