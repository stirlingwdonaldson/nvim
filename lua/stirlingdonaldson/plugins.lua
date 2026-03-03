vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },			-- LSP??
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },		-- LSP
	{ src = "https://github.com/saghen/blink.cmp.git"},			-- text or sumn
	{ src = "https://github.com/nvim-telescope/telescope.nvim.git"},	-- fuzzy finder
	{ src = "https://github.com/nvim-lua/plenary.nvim.git"},		-- dependency for blink
	{ src = "https://github.com/stevearc/oil.nvim.git"},			-- file explorer
	{ src = "https://github.com/kdheepak/lazygit.nvim.git"},		-- lazygit
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },	-- indent
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
	{ src = "https://github.com/bluz71/vim-moonfly-colors.git"},
	{ src = "https://github.com/folke/which-key.nvim.git"},			-- preview of keykbinds
})

require("mason").setup()
require("mason-lspconfig").setup()
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	fuzzy = {
		implementation = "rust",
		prebuilt_binaries = {
			force_version = "v1.9.1",
		}
	}
})
require("telescope").setup()
require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		autosave_changes = true,
	},
	view_options = {
		show_hidden = true,
	},
})


