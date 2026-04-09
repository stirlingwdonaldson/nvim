vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim.git"},
  { src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
})


require("oil").setup({
  view_options = {
    show_hidden = true,
  },
})
require("nvim-web-devicons").setup()

