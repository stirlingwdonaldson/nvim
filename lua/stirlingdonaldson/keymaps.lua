vim.g.mapleader = " "

-- general
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true})

-- oil
vim.keymap.set("n", "q", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true, silent = true})

-- telescope
local builtin = require('telescope.builtin')
local telescope_large_layout = {
  layout_config = {
    width = 0.9,
    height = 0.9,
  },
}

vim.keymap.set("n", "<leader>f", function()
  builtin.find_files(telescope_large_layout)
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>F", function()
  builtin.live_grep(telescope_large_layout)
end, { desc = "Telescope live grep" })

-- formatting
vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true})

-- lazygit
vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { noremap = true, silent = true})

-- trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { noremap = true, silent = true, desc = "Buffer Diagnostics (Trouble)" })
