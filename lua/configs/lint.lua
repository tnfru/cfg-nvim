-- Path: ~/.config/nvim/lua/custom/configs/lint.lua

local lint = require("lint")

-- Configure linters for different filetypes
-- We're removing python from here completely to avoid conflicts with LSP
lint.linters_by_ft = {}

-- Setup autocommand to trigger linting for other filetypes
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

return {}
