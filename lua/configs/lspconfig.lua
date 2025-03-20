-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local python_utils = require "configs.python_utils"

-- Configure servers that don't need special configuration
local basic_servers = { "html", "cssls", "bashls", }
for _, lsp in ipairs(basic_servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- Try to find Python in virtual environment
local python_path = python_utils.find_venv_python()

-- Configure BasedPyright according to the documentation
lspconfig.basedpyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    -- These are the correct settings structure according to the docs
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        diagnosticSeverityOverrides = {
          -- This ensures undefined variables are reported as errors
          -- which is needed for import suggestion code actions
          reportUndefinedVariable = "error",
        },
      },
    },
    python = {
      -- Only pythonPath and venvPath are allowed under python.*
      pythonPath = python_path,
      venvPath = vim.fn.getcwd(),
    }
  }
}

-- Configure Ruff for linting
lspconfig.ruff.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    
    -- Disable hover in favor of BasedPyright
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
        run = "onType",
      },
    },
  },
}
