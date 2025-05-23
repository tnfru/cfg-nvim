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

-- Configure WhichKey
local wk = require "which-key"
wk.setup {
  triggers_nowait = {
    -- your triggers here
  },
}

-- Register groups
wk.add {
  -- LSP group
  { "<leader>l", group = "LSP" },
  -- Code group
  { "<leader>c", group = "Code" },
  -- Goto group
  { "<leader>g", group = "Goto" },
  -- Workspace group
  { "<leader>w", group = "Workspace" },
  -- Diagnostic group
  { "<leader>d", group = "Diagnostics" },
  -- Ruff group
  { "<leader>r", group = "Ruff" },
}

-- Register LSP mappings
wk.add {
  -- LSP commands
  {
    "<leader>lh",
    function()
      vim.lsp.buf.hover()
    end,
    desc = "Hover Documentation",
  },
  { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>",               desc = "Goto Definition" },
  { "<leader>lr", "<cmd>Telescope lsp_references<cr>",                desc = "References" },
  { "<leader>li", "<cmd>Telescope lsp_implementations<cr>",           desc = "Implementations" },
  { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>",          desc = "Type Definitions" },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document Symbols" },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  {
    "<leader>ln",
    function()
      vim.lsp.buf.rename()
    end,
    desc = "Rename",
  },
  {
    "<leader>la",
    function()
      vim.lsp.buf.code_action()
    end,
    desc = "Code Action",
  },
  {
    "<leader>lf",
    function()
      vim.lsp.buf.format()
    end,
    desc = "Format Document",
  },

  -- Code actions
  {
    "<leader>ca",
    function()
      vim.lsp.buf.code_action()
    end,
    desc = "Code Action",
  },
  {
    "<leader>cf",
    function()
      vim.lsp.buf.format()
    end,
    desc = "Format Document",
  },
  {
    "<leader>cr",
    function()
      vim.lsp.buf.rename()
    end,
    desc = "Rename",
  },

  -- Goto commands
  { "<leader>gd", "<cmd>Telescope lsp_definitions<cr>",     desc = "Goto Definition" },
  { "<leader>gr", "<cmd>Telescope lsp_references<cr>",      desc = "Goto References" },
  { "<leader>gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
  {
    "<leader>gD",
    function()
      vim.lsp.buf.declaration()
    end,
    desc = "Goto Declaration",
  },
  { "<leader>gt", "<cmd>Telescope lsp_type_definitions<cr>",          desc = "Goto Type Definition" },

  -- Workspace commands
  {
    "<leader>wa",
    function()
      vim.lsp.buf.add_workspace_folder()
    end,
    desc = "Add Workspace Folder",
  },
  {
    "<leader>wr",
    function()
      vim.lsp.buf.remove_workspace_folder()
    end,
    desc = "Remove Workspace Folder",
  },
  {
    "<leader>wl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    desc = "List Workspace Folders",
  },
  { "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },

  -- Diagnostic commands
  { "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document Symbols" },
  {
    "<leader>dd",
    function()
      vim.diagnostic.setloclist()
    end,
    desc = "List Diagnostics",
  },
  {
    "<leader>df",
    function()
      vim.diagnostic.open_float()
    end,
    desc = "Show Diagnostic",
  },
  {
    "<leader>dp",
    function()
      vim.diagnostic.goto_prev()
    end,
    desc = "Previous Diagnostic",
  },
  {
    "<leader>dn",
    function()
      vim.diagnostic.goto_next()
    end,
    desc = "Next Diagnostic",
  },
  {
    "<leader>dx",
    function()
      require("configs.custom_utils").toggle_diagnostics()
    end,
    desc = "Toggle Diagnostics",
  },

  -- Ruff commands
  { "<leader>ra", "<cmd>RuffAutofix<cr>",         desc = "Autofix All" },
  { "<leader>ri", "<cmd>RuffOrganizeImports<cr>", desc = "Organize Imports" },
}

-- Set up LSP attach event for keymaps and highlighting
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- Standard key mappings that will work regardless of which-key
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf, desc = "LSP: Hover Documentation" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "LSP: Goto Declaration" })
    vim.keymap.set("n", "gd", function()
      require("telescope.builtin").lsp_definitions()
    end, { buffer = event.buf, desc = "LSP: Goto Definition" })
    vim.keymap.set("n", "gr", function()
      require("telescope.builtin").lsp_references()
    end, { buffer = event.buf, desc = "LSP: Goto References" })
    vim.keymap.set("n", "gi", function()
      require("telescope.builtin").lsp_implementations()
    end, { buffer = event.buf, desc = "LSP: Goto Implementation" })

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
