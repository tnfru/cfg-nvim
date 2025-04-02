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
map("n", "<leader>q", vim.diagnostic.open_float)

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

-- Register Avante group
wk.add {
  -- Avante group
  { "<leader>a", group = "Avante" },
}

-- Register Avante mappings
wk.add {
  { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Toggle Avante" },
  { "<leader>aa", "<cmd>AvanteAsk<cr>",    desc = "Ask AI" },
  { "<leader>ac", "<cmd>AvanteChat<cr>",   desc = "Chat with AI" },
  { "<leader>af", "<cmd>AvanteFocus<cr>",  desc = "Focus Avante" },
  { "<leader>as", "<cmd>AvanteStop<cr>",   desc = "Stop Generation" },
  { "<leader>ax", "<cmd>AvanteClear<cr>",  desc = "Clear Chat History" },
}
