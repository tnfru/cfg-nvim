-- Load base NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local python_utils = require "configs.python_utils"

-- Keep virtual environment detection
local python_path = python_utils.find_venv_python()

-- Set up Mason for LSP management
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup {
  ensure_installed = {
    -- LSP servers
    "lua_ls",
    "basedpyright",
    "ruff",
    "html",
    "cssls",
    "bashls",
    "jsonls",
    -- Formatters/Linters
    "stylua",
  },
}

-- Set up Fidget for LSP status updates
require("fidget").setup {
  progress = {
    display = {
      done_icon = "✓",
    },
  },
  notification = {
    window = {
      winblend = 0,
    },
  },
}

-- Enhanced capabilities with nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Set up LSP attach event for keymaps and highlighting
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Keep all the powerful keymaps from the second config
    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    map("<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Set up document highlighting
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Configure basic servers
local basic_servers = { "html", "cssls", "bashls", "jsonls" }
for _, lsp in ipairs(basic_servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = vim.tbl_deep_extend("force", capabilities, nvlsp.capabilities or {}),
  }
end

-- Configure Lua LSP with settings from second config
lspconfig.lua_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = vim.tbl_deep_extend("force", capabilities, nvlsp.capabilities or {}),
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = {
          "${3rd}/luv/library",
          unpack(vim.api.nvim_get_runtime_file("", true)),
        },
      },
      completion = {
        callSnippet = "Replace",
      },
      telemetry = { enable = false },
      diagnostics = { disable = { "missing-fields" } },
    },
  },
}

-- Keep your BasedPyright configuration
lspconfig.basedpyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = vim.tbl_deep_extend("force", capabilities, nvlsp.capabilities or {}),
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "strict",
        diagnosticSeverityOverrides = {
          reportUndefinedVariable = "error",
        },
      },
    },
    python = {
      pythonPath = python_path,
      venvPath = vim.fn.getcwd(),
    },
  },
}

-- Keep your Ruff configuration
lspconfig.ruff.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)

    -- Disable hover in favor of BasedPyright
    client.server_capabilities.hoverProvider = false
  end,
  on_init = nvlsp.on_init,
  capabilities = vim.tbl_deep_extend("force", capabilities, nvlsp.capabilities or {}),
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
  -- Add Ruff commands from second config
  commands = {
    RuffAutofix = {
      function()
        vim.lsp.buf.execute_command {
          command = "ruff.applyAutofix",
          arguments = {
            { uri = vim.uri_from_bufnr(0) },
          },
        }
      end,
      description = "Ruff: Fix all auto-fixable problems",
    },
    RuffOrganizeImports = {
      function()
        vim.lsp.buf.execute_command {
          command = "ruff.applyOrganizeImports",
          arguments = {
            { uri = vim.uri_from_bufnr(0) },
          },
        }
      end,
      description = "Ruff: Format imports",
    },
  },
}
