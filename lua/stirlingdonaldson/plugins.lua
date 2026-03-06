-- Plugin sources
vim.pack.add({
	-- LSP and tooling
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/pmizio/typescript-tools.nvim.git" },
	{ src = "https://github.com/windwp/nvim-ts-autotag.git" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter.git" },

	{ src = "https://github.com/folke/trouble.nvim.git" },

	-- Completion and search
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" },
	{ src = "https://github.com/saghen/blink.cmp.git" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },

	-- Snippets
	{ src = "https://github.com/L3MON4D3/LuaSnip.git" },
	{ src = "https://github.com/rafamadriz/friendly-snippets.git" },

	-- UI and navigation
	{ src = "https://github.com/MunifTanjim/nui.nvim.git" },
	{ src = "https://github.com/nvzone/volt.git" },
	{ src = "https://github.com/folke/noice.nvim.git" },
	{ src = "https://github.com/folke/which-key.nvim.git" },
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	{ src = "https://github.com/mawkler/hml.nvim.git" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim.git" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
	{ src = "https://github.com/max397574/startup.nvim.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/gisketch/triforce.nvim.git" },

	-- Themes
	{ src = "https://github.com/bluz71/vim-moonfly-colors.git" },
	{ src = "https://github.com/dasupradyumna/midnight.nvim.git" },
	{ src = "https://github.com/projekt0n/github-nvim-theme.git" },
	{ src = "https://github.com/stirlingwdonaldson/eigengrau.git" },

	-- Typst
	{ src = "https://github.com/chomosuke/typst-preview.nvim.git" },

	-- Obsidian
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim.git" },

   -- Primeagen
   { src = "https://github.com/ThePrimeagen/vim-be-good.git"},

   -- Color previews
   { src = "https://github.com/brenoprata10/nvim-highlight-colors.git"},

   -- Live server
   { src = "https://github.com/barrett-ruth/live-server.nvim.git" },
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"gopls",
		"clangd",
		"tinymist",
		"tailwindcss",
      "jdtls",
	},
	automatic_enable = {
		exclude = { "ts_ls" },
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP servers
		"lua_ls",
		"pyright",
		"gopls",
		"clangd",
		"tinymist",
		"tailwindcss",

		-- Formatters
		"stylua",
		"prettierd",
		"prettier",
		"black",
		"isort",
		"gofumpt",
		"goimports",
		"google-java-format",
      "biome",
	},
	auto_update = false,
	run_on_start = true,
})

require("nvim-treesitter").setup()

-- Install treesitter parsers if missing
local wanted_parsers = { "html", "typescript", "tsx", "javascript", "css" }
local installed = require("nvim-treesitter").get_installed()
local installed_set = {}
for _, p in ipairs(installed) do
	installed_set[p] = true
end
local to_install = {}
for _, p in ipairs(wanted_parsers) do
	if not installed_set[p] then
		table.insert(to_install, p)
	end
end
if #to_install > 0 then
	require("nvim-treesitter").install(to_install)
end

require("typescript-tools").setup({})
require("nvim-ts-autotag").setup()

require("trouble").setup()
require("typst-preview").setup({})
require("obsidian").setup({
	legacy_commands = false,
	workspaces = {
		{
			name = "zettelkasten",
			path = "/Users/stirlingdonaldson/Documents/zettelkasten/",
		},
	},
	notes_subdir = "notes",
	new_notes_location = "notes_subdir",
	daily_notes = {
		folder = "daily",
	},
	completion = {
		blink = true,
		min_chars = 2,
	},
	picker = {
		name = "telescope.nvim",
	},
})

vim.g.live_server = {}

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

		java = { "google-java-format" },
	},
})

-- UI Helpers
local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	-- Pick a mid-tone color that looks ~50% visible on your theme
	vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3A4050", nocombine = true })
end)
require("ibl").setup({
	indent = {
		highlight = "IblIndent",
		char = "│",
	},
})

require("nvim-highlight-colors").setup({
	render = "virtual",
	enable_named_colors = false,
	enable_tailwind = true,
})

require("noice").setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
})

require("which-key").setup({
	triggers = {
		{ "<leader>", mode = "n" },
		{ "<localleader>", mode = "n" },
	},
})

require("triforce").setup()

local startup_header = {
	"&X                                                      ",
	"                              X                  ;;  +&$                                                    ",
	"                             ;&;+&+             $+    &&&;               :&                                 ",
	"                            &   x$X&+          :&&:  +&&&$           X+  &&&                                ",
	"                           x$.   &&&X           &&&&&&&& $          &$.   &&X                               ",
	"            .              x&&X+&&&&&;          xx::;+.+$          xx&X   &&&X                              ",
	"           &&&&$&$;         &+$&&&$&&              :&&             xX&&&&&&&&:         :.  X$               ",
	"           .   +&X +          :+&&&X                &&              :&&+   +;       X$   +&&X               ",
	"          &     $Xxx              &&                &&.               &&&:         &&X   ;&&&               ",
	"          x$$X.+XXXX              &&$              X :X               $&X          &&&   :&&&               ",
	"           :$$$&&&&+              X;$:             X  X              &&&X          &&&$X++++x               ",
	"                 &&&&             + +&;           X   &             & &&            &X :&&&+                ",
	"                  x&&&x           :  x&;            $ :&          ;$  $$           $&&+                     ",
	"                    &&&&+         ;x& :&;        X &&& x&        :; & &&         :&&&                       ",
	"                     &&&&&x      : $&&X:&$      $:xX :$ &$     :X ;&& &&        $&&:                        ",
	"                      x&&&&&&    & &&  & ;&&+;X; &+   x$ ;&Xx$+  &&&$ +&     :$+&&                          ",
	"                       +&&$  +$X; $&$   ;x     &$;      x   .$&&$&&&&&.$&. XXx+$X                           ",
	"                         $&&&&&X&&&& :      :::             + & X&&&&&&    &&&&&                            ",
	"                         x&&&&&&&&&&+.:                  .     :&&&&&&&&&&&&&$:                             ",
	"                          &&+&&&&&&.$ $           ::;;;+X&$X&x &&&&&&&&&&&&&&+                              ",
	"                           $$+&&&&&&&&&X                       .;.+x&&&&&&&&&                               ",
	"                           x&X: .$&$&&&&&&&&X&$$&&&&&&&$$&&&&&&&&&&&&$:  x&&$                               ",
	"                           &&&&&&&&&&&&&+.               +;+&&$&&&&&&&&&&&&&&&                              ",
	"                           x$&&&&&&&& &&$          +X    ; ++&&&&$$&&&&&&&&&&X                              ",
	"                              $&&&$&&&&&&&$X   .&&&&&&$+;  &X$&&&&&&&&X&&&&                                 ",
	"                             $$&&&&&&&&$$+;       x$$:     $$&&&&&&&&&&&&$&                                 ",
	"                             :x+x$:$::+$$X                  :;&&&&&&&&&&&&&X                                ",
	"                              X&&&X$x;+$;      .          +&&&&&&&&&&&&&&&                                  ",
	"                            ;$&&&                             +&&&&$&&&&&$                                  ",
	"                           .$X$&&&X$&&&&&&&$&&&&&&&&&&&&$$&&$&&&&&&&&&&&&&&x                                ",
	"                            x&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&x&X$$&&&&&&&&X&;                                ",
	"                                   ::;xX&&&&&&&&&&&&&&&&&&&&$&$XX$$+.                                       ",
}

vim.api.nvim_set_hl(0, "StartupWhite", { fg = "#ffffff" })

require("startup").setup({
	section_header = {
		type = "text",
		align = "center",
		fold_section = false,
		title = "Header",
		margin = 5,
		content = startup_header,
		highlight = "StartupWhite",
	},
	section_commands = {
		type = "mapping",
		align = "center",
		fold_section = false,
		title = "Commands",
		margin = 5,
		content = {
			{ "Open file explorer", "Oil", "<leader>e" },
			{ "Find files", "Telescope find_files", "<leader>f" },
			{ "Open lazygit", "LazyGit", "<leader>lg" },
			{ "Quit Neovim", "qa", "<leader>Q" },
		},
		highlight = "String",
	},
	options = {
		mapping_keys = true,
		cursor_column = 0.5,
		empty_lines_between_mappings = true,
		disable_statuslines = false,
		paddings = { 1, 2 },
	},
	parts = { "section_header", "section_commands" },
})

-- Completion
require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "rust",
		prebuilt_binaries = {
			force_version = "v1.9.1",
		},
	},
})

-- Snippets
local ls = require("luasnip")

ls.setup({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged",
})

require("luasnip.loaders.from_vscode").lazy_load()

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

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
