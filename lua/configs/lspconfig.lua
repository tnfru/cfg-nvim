-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local python_utils = require "configs.python_utils"

-- Configure servers that don't need special configuration
local basic_servers = { "html", "cssls", "bashls", "ruff", "pyright" }
for _, lsp in ipairs(basic_servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Try to find Python in virtual environment
local python_path = python_utils.find_venv_python()
--
-- Configure Pyright
lspconfig.pyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    python = {
      pythonPath = python_path,
    },
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    analysis = {
      -- Disable linting to use Ruff for linting
      useLibraryCodeForTypes = true,
      autoSearchPaths = true,
      diagnosticMode = "workspace",
      typeCheckingMode = "basic", -- Can be "off", "basic", or "strict"
    },
  },
}

-- Configure Ruff
lspconfig.ruff.setup {
  on_attach = function(client, bufnr)
    -- Call the default on_attach first
    nvlsp.on_attach(client, bufnr)

    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,
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
