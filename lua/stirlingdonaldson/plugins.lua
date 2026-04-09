vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" },

	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },

	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/junegunn/fzf.vim.git" },
})

require("nvim-web-devicons").setup()

require("mason").setup()
require("mason-lspconfig").setup()

require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")

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

-- oil bg color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
