print("working!")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", ":Ex<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true})
