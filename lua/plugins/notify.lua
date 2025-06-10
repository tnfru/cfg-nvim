-- lua/plugins/notify.lua
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require "notify"

    notify.setup {
      -- This provides a default background color for the notification windows,
      -- resolving the error caused by a transparent 'NormalFloat' highlight.
      -- We're using the base background of your 'onenord' theme for consistency.
      background_colour = "#2D3540",
    }

    -- This makes the notify function available globally
    vim.notify = notify
  end,
}
