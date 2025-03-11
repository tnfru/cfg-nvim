-- Path: ~/.config/nvim/lua/custom/configs/lint.lua

local lint = require("lint")

-- Create a custom pylint linter that uses the project's virtual environment
lint.linters.pylint_venv = {
  -- Clone the default pylint configuration
  cmd = function()
    -- Check for pylint in the project's virtual environment
    local venv_pylint = vim.fn.getcwd() .. "/.venv/bin/pylint"
    if vim.fn.filereadable(venv_pylint) == 1 then
      return venv_pylint
    end
    -- Fallback to system pylint
    return "pylint"
  end,
  -- Keep the rest of pylint's configuration
  stdin = lint.linters.pylint.stdin,
  args = lint.linters.pylint.args,
  stream = lint.linters.pylint.stream,
  ignore_exitcode = lint.linters.pylint.ignore_exitcode,
  parser = lint.linters.pylint.parser,
}

-- Configure linters for different filetypes - use our custom venv-aware pylint
lint.linters_by_ft = {
  python = {"pylint_venv"},  -- Changed from "pylint" to "pylint_venv"
}

-- Setup autocommand to trigger linting when entering or writing to a buffer
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

return {}  -- Return empty table as we're setting up directly
