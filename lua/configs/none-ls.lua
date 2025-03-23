local null_ls = require("null-ls")
local python_utils = require "configs.python_utils"

-- Try to find Python in virtual environment
local python_path = python_utils.find_venv_python()

local opts = {
  debug = false,
  sources = {
    -- Your null-ls sources will go here
    -- We're not adding any Python linters here since you're using Ruff through LSP
    -- Examples of other potential sources
    -- null_ls.builtins.formatting.prettier,
    -- null_ls.builtins.diagnostics.eslint,
    -- null_ls.builtins.completion.spell,
  },
  -- Use this to set up on_attach with the proper capabilities and other options
  on_attach = function(client, bufnr)
    -- You can copy over the on_attach function from your lspconfig.lua
    local lspconfig = require("nvchad.configs.lspconfig")
    lspconfig.on_attach(client, bufnr)
  end,
}

-- Initialize and return the config
null_ls.setup(opts)
