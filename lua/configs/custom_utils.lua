-- lua/configs/custom_utils.lua
local M = {}

-- =========================================================================
-- C O N F I G U R A T I O N
-- =========================================================================
local config = {
  -- Set to `true` for diagnostics to be ON when you open a file.
  -- Set to `false` for diagnostics to be OFF when you open a file.
  diagnostics_on_by_default = true,
}
-- =========================================================================

function M.toggle_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()

  local current_state = vim.b[bufnr].diagnostics_enabled
  if current_state == nil then
    current_state = config.diagnostics_on_by_default
  end

  if not current_state then
    vim.diagnostic.enable(true, { bufnr = bufnr })
    vim.b[bufnr].diagnostics_enabled = true
    -- CORRECTED: The log level is now inside the options table.
    vim.notify("Diagnostics: ON", "info", { title = "LSP" })
  else
    vim.diagnostic.enable(false, { bufnr = bufnr })
    vim.b[bufnr].diagnostics_enabled = false
    -- CORRECTED: The log level is now inside the options table.
    vim.notify("Diagnostics: OFF", "info", { title = "LSP" })
  end
end

function M.set_initial_diagnostic_state(event)
  if vim.b[event.buf].diagnostics_enabled == nil then
    vim.diagnostic.enable(config.diagnostics_on_by_default, { bufnr = event.buf })
    vim.b[event.buf].diagnostics_enabled = config.diagnostics_on_by_default
  end
end

return M

