-- lua/configs/lspconfig.lua

require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local custom_utils = require "configs.custom_utils"

local original_on_attach = nvlsp.on_attach
nvlsp.on_attach = function(client, bufnr)
  original_on_attach(client, bufnr)
  custom_utils.set_initial_diagnostic_state({ buf = bufnr })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover Documentation" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP: Goto Declaration" })
  vim.keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions() end, { buffer = bufnr, desc = "LSP: Goto Definition" })
  vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end, { buffer = bufnr, desc = "LSP: Goto References" })
  vim.keymap.set("n", "gi", function() require("telescope.builtin").lsp_implementations() end, { buffer = bufnr, desc = "LSP: Goto Implementation" })

  if client and client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { buffer = bufnr, callback = vim.lsp.buf.document_highlight })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { buffer = bufnr, callback = vim.lsp.buf.clear_references })
  end
end

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
  local opts = {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = capabilities,
  }

  if server_name == "lua_ls" then
    opts.settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = { checkThirdParty = false, library = { "${3rd}/luv/library", vim.api.nvim_get_runtime_file("", true) } },
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
        },
      },
      python = {
        pythonPath = vim.g.python3_host_prog,
      },
    }
  end

  if server_name == "ruff" then
    opts.on_attach = function(client, bufnr)
      nvlsp.on_attach(client, bufnr)
      client.server_capabilities.hoverProvider = false
    end
    opts.settings = {
      python = {
        pythonPath = vim.g.python3_host_prog,
      },
    }
  end

  lspconfig[server_name].setup(opts)
end

require("fidget").setup {
  progress = { display = { done_icon = "✓" } },
  notification = { window = { winblend = 0 } },
}

local wk = require "which-key"
wk.setup { triggers_nowait = {} }

wk.add {
  { "<leader>l", group = "LSP" },
  { "<leader>c", group = "Code" },
  { "<leader>g", group = "Goto" },
  { "<leader>w", group = "Workspace" },
  { "<leader>d", group = "Diagnostics" },
  { "<leader>r", group = "Ruff" },
}

wk.add {
  { "<leader>lh", function() vim.lsp.buf.hover() end, desc = "Hover Documentation" },
  { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
  { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
  { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
  { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definitions" },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  { "<leader>ln", function() vim.lsp.buf.rename() end, desc = "Rename" },
  { "<leader>la", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
  { "<leader>lf", function() vim.lsp.buf.format() end, desc = "Format Document" },
  { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
  { "<leader>cf", function() vim.lsp.buf.format() end, desc = "Format Document" },
  { "<leader>cr", function() vim.lsp.buf.rename() end, desc = "Rename" },
  { "<leader>gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
  { "<leader>gr", "<cmd>Telescope lsp_references<cr>", desc = "Goto References" },
  { "<leader>gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
  { "<leader>gD", function() vim.lsp.buf.declaration() end, desc = "Goto Declaration" },
  { "<leader>gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto Type Definition" },
  { "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add Workspace Folder" },
  { "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove Workspace Folder" },
  { "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "List Workspace Folders" },
  { "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
  { "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>dd", function() vim.diagnostic.setloclist() end, desc = "List Diagnostics" },
  { "<leader>df", function() vim.diagnostic.open_float() end, desc = "Show Diagnostic" },
  { "<leader>dp", function() vim.diagnostic.goto_prev() end, desc = "Previous Diagnostic" },
  { "<leader>dn", function() vim.diagnostic.goto_next() end, desc = "Next Diagnostic" },
  { "<leader>dx", function() require("configs.custom_utils").toggle_diagnostics() end, desc = "Toggle Diagnostics" },
  { "<leader>ra", "<cmd>RuffAutofix<cr>", desc = "Autofix All" },
  { "<leader>ri", "<cmd>RuffOrganizeImports<cr>", desc = "Organize Imports" },
}
