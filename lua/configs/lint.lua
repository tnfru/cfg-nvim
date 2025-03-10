-- Path: ~/.config/nvim/lua/custom/configs/lint.lua

local lint = require("lint")

-- Configure linters for different filetypes
lint.linters_by_ft = {
  python = {"pylint"},
}

-- You can add custom configurations for pylint if needed
-- lint.linters.pylint.args = {}

-- Setup autocommand to trigger linting when entering or writing to a buffer
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

return {}  -- Return empty table as we're setting up directly
