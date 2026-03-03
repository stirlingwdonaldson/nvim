-- Plugin sources
vim.pack.add({
	-- LSP and tooling
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },

	-- Completion and search
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" },
	{ src = "https://github.com/saghen/blink.cmp.git" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },

	-- UI and navigation
	{ src = "https://github.com/MunifTanjim/nui.nvim.git" },
	{ src = "https://github.com/folke/noice.nvim.git" },
	{ src = "https://github.com/folke/which-key.nvim.git" },
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	{ src = "https://github.com/mawkler/hml.nvim.git" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim.git" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
	{ src = "https://github.com/rcarriga/nvim-notify.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },

	-- Themes
	{ src = "https://github.com/bluz71/vim-moonfly-colors.git" },
	{ src = "https://github.com/dasupradyumna/midnight.nvim.git" },
	{ src = "https://github.com/projekt0n/github-nvim-theme.git" },
})

-- LSP
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"ts_ls",
		"pyright",
		"gopls",
		"clangd",
	},
	automatic_enable = true,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP servers
		"lua_ls",
		"ts_ls",
		"pyright",
		"gopls",
		"clangd",

		-- Formatters
		"stylua",
		"prettierd",
		"prettier",
		"black",
		"isort",
		"gofumpt",
		"goimports",
	},
	auto_update = false,
	run_on_start = true,
})

-- Formatting
local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },

		javascript = { "prettierd", "prettier" },
		javascriptreact = { "prettierd", "prettier" },
		typescript = { "prettierd", "prettier" },
		typescriptreact = { "prettierd", "prettier" },

		json = { "prettierd", "prettier" },
		yaml = { "prettierd", "prettier" },
		markdown = { "prettierd", "prettier" },

		python = { "isort", "black" },
		go = { "goimports", "gofumpt" },
	},
})

vim.api.nvim_create_user_command("Format", function()
	conform.format({
		async = false,
		lsp_fallback = true,
	})
end, { desc = "Format current buffer" })

-- UI helpers
require("ibl").setup()
require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
})

-- Completion
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	fuzzy = {
		implementation = "rust",
		prebuilt_binaries = {
			force_version = "v1.9.1",
		},
	},
})

-- Navigation
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

local function display_absolute_path()
	local filepath = vim.fn.expand("%:p")
	local home = vim.fn.expand("~")
	if filepath:sub(1, #home) == home then
		return "~" .. filepath:sub(#home + 1)
	end
	return filepath
end

-- Statusline
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "iceberg_dark",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16,
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { display_absolute_path },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
