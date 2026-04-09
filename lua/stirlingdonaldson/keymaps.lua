vim.g.mapleader = " "


vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true})

vim.keymap.set("n", "q", "<cmd>close<CR>")

vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { noremap = true, silent = true})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = 'Telescope live grep' })
