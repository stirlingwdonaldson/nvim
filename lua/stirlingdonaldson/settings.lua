-- Editor behavior
vim.o.clipboard = "unnamedplus"
vim.o.smartindent = true
vim.wo.relativenumber = true

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 3
vim.o.softtabstop = 3
vim.o.tabstop = 3

-- UI
vim.g.have_nerd_font = true
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.cmd("colorscheme github_dark_high_contrast")
