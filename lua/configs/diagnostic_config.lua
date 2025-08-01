-- Disable virtual text diagnostics
-- Apply immediately to override NvChad defaults
vim.diagnostic.config({
  virtual_text = false,
  signs = { text = { [vim.diagnostic.severity.ERROR] = "󰅙", [vim.diagnostic.severity.WARN] = "", [vim.diagnostic.severity.INFO] = "󰋼", [vim.diagnostic.severity.HINT] = "󰌵" } },
  underline = true,
  float = { border = "single" },
})

-- Also set up an autocmd to ensure it sticks after LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("disable-virtual-text", { clear = true }),
  callback = function()
    vim.diagnostic.config({ virtual_text = false })
  end,
})