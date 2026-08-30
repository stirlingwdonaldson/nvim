vim.pack.add({
	-- general dependencies
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" },
	{ src = "https://github.com/MunifTanjim/nui.nvim.git" }, -- required by neo-tree and noice

	-- lsp plugins
	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls.git" },
	{ src = "https://github.com/saghen/blink.cmp.git", version = "v1.10.2" },
	{ src = "https://github.com/rafamadriz/friendly-snippets.git" },

	-- treesitter: parses buffers into a syntax tree, used below by
	-- render-markdown.nvim (and available for anything else that wants it).
	-- Using the "main" branch (the actively developed rewrite) rather than
	-- "master" (frozen legacy API) since main tracks nightly Neovim's
	-- internals much more closely - master's older query-predicate code
	-- was crashing on markdown's injection queries.
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter.git" },

	-- renders markdown nicely in-buffer (headings, tables, checkboxes, code
	-- blocks) instead of showing raw # and | characters
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim.git" },

	-- lsp ui: peek definitions/references and a nicer code action menu
	{ src = "https://github.com/DNLHC/glance.nvim.git" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim.git" },

	-- formatting and linting (replaces calling vim.lsp.buf.format() directly)
	{ src = "https://github.com/stevearc/conform.nvim.git" },
	{ src = "https://github.com/mfussenegger/nvim-lint.git" },

	-- diagnostics rendered inline, next to the offending code
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim.git" },

	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim.git" },
	{ src = "https://github.com/ibhagwan/fzf-lua.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim.git" },
	{ src = "https://github.com/stevearc/aerial.nvim.git" },
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" },
  { src = "https://github.com/folke/trouble.nvim.git"},

  -- general editor ui polish
  { src = "https://github.com/folke/noice.nvim.git" },
  { src = "https://github.com/folke/which-key.nvim.git" },

  -- local LLM command lookup, backed by Ollama running on your machine
  { src = "https://github.com/David-Kunz/gen.nvim.git" },

  -- colorscheme
  { src = "https://github.com/EdenEast/nightfox.nvim.git"},
})

require("nvim-web-devicons").setup()

require("mason").setup({
	PATH = "prepend",
})
require("mason-lspconfig").setup({
	ensure_installed = { "vtsls", "tailwindcss", "pyright", "jdtls" },
	automatic_enable = { exclude = { "ts_ls" } },
})

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
require("telescope").load_extension("lazygit")

-- fzf-lua is a second, faster fuzzy finder (backed by the real fzf binary)
-- kept alongside telescope rather than replacing it - see <leader>z keymaps.
require("fzf-lua").setup({})

local oil_util = require("oil.util")
local orig_get_icon_provider = oil_util.get_icon_provider
oil_util.get_icon_provider = function(...)
	local orig = orig_get_icon_provider(...)
	return function(type, name, conf)
		local icon, hl = orig(type, name, conf)
		if type == "directory" and name:match("^_") then
			hl = "OilDirIconPurple"
		end
		return icon, hl
	end
end

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	delete_to_trash = true,

})

-- neo-tree is a sidebar file tree, complementary to oil's buffer-based
-- browsing - handy for keeping a project's shape visible while you work.
require("neo-tree").setup({
	close_if_last_window = true,
})

-- aerial gives a jump-to-symbol outline, useful for orienting yourself in
-- namespace-heavy files (e.g. a large Java class with many methods).
require("aerial").setup({
	layout = {
		min_width = 28,
	},
})

require("trouble").setup({
	focus = false,
})

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  fuzzy = {
    implementation = "rust",
    prebuilt_binaries = {
      force_version = "v1.6.0",
    },
  },

  completion = {
    menu = {
      border = "none",
    },
  },
})

-- treesitter (main branch): the installer lives in a submodule, not on
-- the top-level require("nvim-treesitter") table. This only installs the
-- parsers - it doesn't auto-enable core syntax highlighting, which suits
-- us: render-markdown.nvim does its own rendering straight off the parser
-- and doesn't need core's treesitter highlighting turned on. Installation
-- happens the first time Neovim starts (a one-time background job -
-- restart Neovim once if rendering doesn't appear on the very first run).
require("nvim-treesitter.install").ensure_installed("markdown", "markdown_inline")

-- render-markdown.nvim: turns raw markdown syntax into a rendered view
-- (styled headings, boxed tables, checkbox icons, highlighted code blocks)
-- directly in the buffer, dropping back to raw text on the cursor's line
-- so you can still edit it. Toggle with <leader>mr if you need raw text.
require("render-markdown").setup({})

-- glance peeks definitions/references/implementations in a floating window
-- without moving your cursor away from where you were reading.
require("glance").setup({})

-- actions-preview shows a diff of what a code action will actually do
-- before you apply it (used by the <leader>ca keymap).
require("actions-preview").setup({})

-- conform runs dedicated formatter CLIs (install them via :Mason or your
-- system package manager, e.g. `brew install stylua prettier`).
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		python = { "black" },
		java = { "google-java-format" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback", -- fall back to the LSP formatter if no CLI formatter matches
	},
})

-- nvim-lint runs dedicated linter CLIs on save (install via :Mason).
require("lint").linters_by_ft = {
	python = { "ruff" },
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
}
vim.api.nvim_create_autocmd("BufWritePost", {
	desc = "Run nvim-lint on save",
	callback = function()
		require("lint").try_lint()
	end,
})

-- tiny-inline-diagnostic renders diagnostics as compact inline text right
-- next to the offending code (settings.lua turns off the default
-- virtual_text renderer so the two don't draw on top of each other).
require("tiny-inline-diagnostic").setup()

-- noice.nvim redraws the cmdline, messages and LSP hover/signature popups
-- with a nicer floating-window UI instead of the classic bottom line.
require("noice").setup({
	presets = {
		lsp_doc_border = true, -- add a border to hover/signature-help windows
	},
})

-- which-key shows a popup of available keybinds and their descriptions
-- whenever you pause after pressing a prefix like <leader>.
require("which-key").setup({
	win = {
		border = "rounded",
		-- Anchor the popup near the bottom-right corner of the screen
		-- instead of the default bottom-center placement.
		row = -1,
		col = -1,
	},
})

-- gen.nvim talks to a local Ollama server - nothing leaves your machine.
-- Install Ollama and pull a small, fast model first:
--   brew install ollama
--   ollama pull qwen2.5-coder:1.5b
require("gen").setup({
	model = "qwen2.5-coder:1.5b", -- small model, chosen for snappy replies over raw power
	display_mode = "float", -- show the answer in a floating window
	show_prompt = false, -- don't echo your question back in the result
	show_model = false,
})

-- Custom prompt: describe what you want in plain English, get back just the
-- command to run - no explanation, no markdown fencing.
require("gen").prompts["Command_Lookup"] = {
	prompt = "You are a terminal and Neovim command expert. Given this "
		.. "request, respond with ONLY the exact command(s) needed, and "
		.. "nothing else:\n$input",
	replace = false,
}

-- oil bg color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "OilDirIconPurple", { fg = "#9d79d6" })
