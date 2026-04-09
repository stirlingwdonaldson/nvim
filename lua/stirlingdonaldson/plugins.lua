vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
  { src = "https://github.com/stevearc/oil.nvim.git"},
})

require("nvim-web-devicons").setup()

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  delete_to_trash = true,

float = {
    padding = 1,
    max_width = 0.5,
    max_height = 0.5,
    border = "rounded",
    win_options = {
      winblend = 5,
    },
  },
})



-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
