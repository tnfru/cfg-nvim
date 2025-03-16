-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local util = require "lspconfig.util"
local python_utils = require "configs.python_utils"

-- Configure servers that don't need special configuration
local basic_servers = { "html", "cssls", "bashls" }
for _, lsp in ipairs(basic_servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Try to find Python in virtual environment
local python_path = python_utils.find_venv_python()

-- Configure Ruff
lspconfig.ruff.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      pythonPath = python_path,
    },
    ruff = {
      lint = {
        run = "onSave",
      },
    },
  },
}

