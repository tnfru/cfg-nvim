local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_format" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    terraform = { "terraform_fmt" },
  },

  -- shfmt: force 4-space indent (preserves the previous none-ls `-i 4`).
  -- Replacing args is required so conform's shiftwidth-based default (-i 2 here)
  -- doesn't append a second, winning -i flag.
  formatters = {
    shfmt = { args = { "-i", "4", "-filename", "$FILENAME" } },
  },

  -- Single source of truth for formatting: conform on save, with native LSP used
  -- only for filetypes conform doesn't handle, so nothing is ever formatted twice.
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

return options
