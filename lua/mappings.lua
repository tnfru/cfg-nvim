require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del
local wk = require "which-key"

-- Disable default NvChad window navigation mappings
unmap("n", "<C-h>")
unmap("n", "<C-j>")
unmap("n", "<C-k>")
unmap("n", "<C-l>")

-- setup tmux / vim combined navigation
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true, noremap = true })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true, noremap = true })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true, noremap = true })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { silent = true, noremap = true })

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>", { desc = "Exit insert mode by pressing jk quickly" })

map("n", "x", '"_x', { desc = "Dont copy char deleted by x" })
--
-- save and quit using ctrl
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map({ "n", "i", "v" }, "<C-q>", "<cmd> q <cr>")

-- scroll
map("n", "L", "L5<C-e>", { noremap = true, desc = "Move to bottom line and scroll" })
map("n", "H", "H5<C-y>", { noremap = true, desc = "Move to top line and scroll" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- resize buffer
map("n", "<Up>", ":resize -2<CR>")
map("n", "<Down>", ":resize +2<CR>")
map("n", "<Left>", ":vertical resize -2<CR>")
map("n", "<Right>", ":vertical resize +2<CR>")
map("n", "<leader>se", "<C-w>=")
map("n", "<leader>v", "<C-w>v", { noremap = true })

-- tabs
map("n", "<leader>to", ":tabnew<CR>")
map("n", "<leader>tx", ":tabclose<CR>")
map("n", "<leader>tn", ":tabn<CR>")
map("n", "<leader>tp", ":tabp<CR>")

-- stay in v mode after indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- diagnostic
map("n", "<leader>d", vim.diagnostic.setloclist)
map("n", "<leader>q", function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local diagnostics = vim.diagnostic.get(0, { lnum = cursor[1] - 1 })

  local float_bufnr, float_winnr = vim.diagnostic.open_float({ focusable = true })
  if not float_bufnr then return end

  vim.api.nvim_set_current_win(float_winnr)

  local function close()
    pcall(vim.api.nvim_win_close, float_winnr, true)
  end

  vim.keymap.set("n", "q", close, { buffer = float_bufnr, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = float_bufnr, silent = true })

  for i, diag in ipairs(diagnostics) do
    if diag.code and diag.source and diag.source:lower():find("ruff") then
      vim.keymap.set("n", tostring(i), function()
        vim.ui.open("https://docs.astral.sh/ruff/rules/" .. diag.code)
        close()
      end, { buffer = float_bufnr, silent = true })
    end
  end
end)

-- Simple save without format
map("n", "<leader>sw", "<cmd>noautocmd w<cr>", { desc = "Save without formatting" })

wk.add {
  { "<leader>s",  group = "Save" },
  { "<leader>sw", "<cmd>noautocmd w<cr>", desc = "Save without formatting" },

  { "<leader>t",  group = "Tabs" },
  { "<leader>to", ":tabnew<CR>",          desc = "Open New Tab" },
  { "<leader>tx", ":tabclose<CR>",        desc = "Close Tab" },
  { "<leader>tn", ":tabn<CR>",            desc = "Next Tab" },
  { "<leader>tp", ":tabp<CR>",            desc = "Previous Tab" },
}
