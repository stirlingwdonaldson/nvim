vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- General
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":wqa<CR>", opts)

-- File explorer and search
map("n", "<C-F>", "<CMD>Open .<CR>", opts)
map("n", "<leader>e", "<CMD>Oil<CR>", opts)
map("n", "<leader>f", "<CMD>Telescope find_files<CR>", opts)

-- LSP and formatting
map("n", "<leader>lf", "<CMD>Format<CR>", opts)

-- Version control
map("n", "<leader>lg", "<CMD>LazyGit<CR>", opts)

-- Command-line convenience
map({ "n", "v", "x" }, ";", ":", opts)
map({ "n" }, "<leader><leader>", ":", opts)
