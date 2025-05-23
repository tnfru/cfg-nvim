local null_ls = require "null-ls"

-- Set up mason integration for none-ls
require("mason-null-ls").setup {
  ensure_installed = {
    "checkmake",
    "prettier",
    "stylua",
    "eslint_d",
    "shfmt",
    "ruff",
  },
  automatic_installation = true,
}

-- Define sources for null-ls
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local sources = {
  -- From your provided config
  diagnostics.checkmake,
  formatting.prettier.with { filetypes = { "html", "json", "yaml", "markdown" } },
  formatting.stylua,
  formatting.shfmt.with { args = { "-i", "4" } },
  formatting.terraform_fmt,
  require("none-ls.formatting.ruff").with { extra_args = { "--extend-select", "I" } },
  require "none-ls.formatting.ruff_format",
}

-- Set up format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Initialize null-ls
null_ls.setup {
  -- debug = true, -- Enable for troubleshooting
  sources = sources,
  on_attach = function(client, bufnr)
    -- Use nvchad's on_attach for consistent behavior
    local lspconfig = require "nvchad.configs.lspconfig"
    lspconfig.on_attach(client, bufnr)

    -- Set up format on save
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end
  end,
}
