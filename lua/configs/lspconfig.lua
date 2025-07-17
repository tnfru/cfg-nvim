-- lua/configs/lspconfig.lua

-- Load base NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Set up common LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local servers = {
  "lua_ls",
  "basedpyright",
  "ruff",
  "html",
  "cssls",
  "bashls",
  "jsonls",
}

for _, server_name in ipairs(servers) do
  -- Default options for all servers
  local opts = {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = capabilities,
  }

  -- Add custom settings for specific servers
  if server_name == "lua_ls" then
    opts.settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { "${3rd}/luv/library", vim.api.nvim_get_runtime_file("", true) },
        },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        diagnostics = { disable = { "missing-fields" } },
      },
    }
  end

  if server_name == "basedpyright" then
    opts.settings = {
      basedpyright = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "strict",
          diagnosticSeverityOverrides = {
            reportUnknownMemberType = "warning",
            reportUnknownVariableType = "warning",
            reportUnknownArgumentType = "warning",
            reportUnknownParameterType = "warning",
            reportMissingParameterType = "warning",
            reportMissingTypeStubs = "warning",
            -- Add any other "strict" rules you want as warnings here.
          },
        },
      },
      python = {
        -- Your plugin's variable is used here!
        pythonPath = vim.g.python3_host_prog,
      },
    }
  end

  if server_name == "ruff" then
    -- Disable ruff's hover provider in favor of basedpyright
    opts.on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      client.server_capabilities.hoverProvider = false
    end
    opts.settings = {
      python = {
        -- Your plugin's variable is used here!
        pythonPath = vim.g.python3_host_prog,
      },
    }
  end

  -- Finally, set up the server with the calculated options
  lspconfig[server_name].setup(opts)
end

-- All keymappings and autocommands below can stay exactly the same.
-- Their setup is independent of how the LSP servers are configured.

-- Fidget for LSP status updates
require("fidget").setup {
  progress = { display = { done_icon = "✓" } },
  notification = { window = { winblend = 0 } },
}

local wk = require "which-key"
wk.setup { triggers_nowait = {} }

-- Register groups
wk.add {
  { "<leader>l", group = "LSP" },
  { "<leader>c", group = "Code" },
  { "<leader>g", group = "Goto" },
  { "<leader>w", group = "Workspace" },
  { "<leader>d", group = "Diagnostics" },
  { "<leader>r", group = "Ruff" },
}

-- Register LSP mappings
wk.add {
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
  { "<leader>gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
  { "<leader>gr", "<cmd>Telescope lsp_references<cr>",  desc = "Goto References" },
  {
    "<leader>gi",
    "<cmd>Telescope lsp_implementations<cr>",
    desc = "Goto Implementation",
  },
  {
    "<leader>gD",
    function()
      vim.lsp.buf.declaration()
    end,
    desc = "Goto Declaration",
  },
  {
    "<leader>gt",
    "<cmd>Telescope lsp_type_definitions<cr>",
    desc = "Goto Type Definition",
  },
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
  { "<leader>ra", "<cmd>RuffAutofix<cr>",         desc = "Autofix All" },
  { "<leader>ri", "<cmd>RuffOrganizeImports<cr>", desc = "Organize Imports" },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
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
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd(
        { "CursorHold", "CursorHoldI" },
        { buffer = event.buf, callback = vim.lsp.buf.document_highlight }
      )
      vim.api.nvim_create_autocmd(
        { "CursorMoved", "CursorMovedI" },
        { buffer = event.buf, callback = vim.lsp.buf.clear_references }
      )
    end
  end,
})
