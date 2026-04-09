vim.g.mapleader = " "

-- general
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true})

-- oil
vim.keymap.set("n", "q", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { noremap = true, silent = true})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>F", builtin.live_grep, { desc = "Telescope live grep" })

-- formatting
vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true})

-- lazygit

vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { noremap = true, silent = true})
