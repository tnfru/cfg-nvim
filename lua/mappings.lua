require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>", { desc = "Exit insert mode by pressing jk quickly"})

map("n", "x", '"_x', { desc = "Dont copy char deleted by x"})
--
-- save and quit using ctrl
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map({ "n", "i", "v" }, "<C-q>", "<cmd> q <cr>")

-- scroll
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- resize buffer
map("n", "<Up>", ":resize -2<CR>")
map("n", "<Down>", ":resize +2<CR>")
map("n", "<Left>", ":vertical resize -2<CR>")
map("n", "<Right>", ":vertical resize +2<CR>")
map("n", "<leader>se", "<C-w>=")

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
