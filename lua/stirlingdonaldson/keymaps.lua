
vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local map = vim.keymap.set


-- Version Control

map("n", "<leader>lg", "<CMD>LazyGit<CR>",opts)


-- File Exploring


map("n", "<C-F>", "<CMD>Open .<CR>", opts)
map("n", "<leader>e", "<CMD>Oil<CR>", opts)

-- Misc


map({ "n", "v", "x" }, ";", ":", opts)
