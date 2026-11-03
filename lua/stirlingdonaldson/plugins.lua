local cpp_project_markers = {
	"compile_commands.json",
	"compile_flags.txt",
	"CMakeLists.txt",
	".clangd",
	".clang-format",
}

local function in_cpp_project(path)
	local start = vim.fs.dirname(path)
	return start and vim.fs.root(start, cpp_project_markers) ~= nil
end

vim.filetype.add({
	extension = {
		-- Neovim normally treats .h as C. In a CMake/clangd-style C++ project,
		-- headers are usually C++ and should get cpp LSP/format/lint settings.
		cc = "cpp",
		cpp = "cpp",
		cxx = "cpp",
		["c++"] = "cpp",
		cppm = "cpp",
		h = function(path)
			return in_cpp_project(path) and "cpp" or "c"
		end,
		["h++"] = "cpp",
		hh = "cpp",
		hpp = "cpp",
		hxx = "cpp",
		ipp = "cpp",
		ixx = "cpp",
		tpp = "cpp",

		-- Neovim's builtin filetype detection maps .pl to Perl by default;
		-- Prolog files commonly use the same extension, so without this prolog_ls
		-- never attaches to them. Prefer .pro/.prolog if you want to avoid this
		-- ambiguity entirely.
		pl = "prolog",
	},
})

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
	{ src = "https://github.com/folke/trouble.nvim.git" },

	-- general editor ui polish
	{ src = "https://github.com/folke/noice.nvim.git" },
	{ src = "https://github.com/folke/which-key.nvim.git" },

	-- local LLM command lookup, backed by Ollama running on your machine
	{ src = "https://github.com/David-Kunz/gen.nvim.git" },

	-- colorscheme
	{ src = "https://github.com/EdenEast/nightfox.nvim.git" },

	-- git blame
	{ src = "https://github.com/f-person/git-blame.nvim.git" },

	-- live browser preview of typst files (driven by <leader>t)
	{ src = "https://github.com/chomosuke/typst-preview.nvim.git" },

	-- Features from the VM configuration.
	{ src = "https://github.com/lewis6991/gitsigns.nvim.git" },
	{ src = "https://github.com/windwp/nvim-autopairs.git" },
	{ src = "https://github.com/folke/ts-comments.nvim.git" },
	{ src = "https://github.com/kylechui/nvim-surround.git" },
	{ src = "https://github.com/folke/persistence.nvim.git" },
	{ src = "https://github.com/folke/flash.nvim.git" },
	{ src = "https://github.com/folke/todo-comments.nvim.git" },
	{ src = "https://github.com/sindrets/diffview.nvim.git" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim.git" },
	{ src = "https://github.com/akinsho/bufferline.nvim.git" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim.git" },
	{ src = "https://github.com/folke/tokyonight.nvim.git" },
})

require("nvim-web-devicons").setup()

require("mason").setup({
	PATH = "prepend",
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--fallback-style=Google",
		"--header-insertion=iwyu",
	},
})

-- tinymist: typst language server (completion, diagnostics, hover, go to
-- definition). Formatting goes through the LSP using typstyle, which conform
-- falls back to on save since there's no typst CLI formatter configured.
vim.lsp.config("tinymist", {
	settings = {
		formatterMode = "typstyle",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = { "vtsls", "tailwindcss", "pyright", "jdtls", "clangd", "cmake", "tinymist", "lua_ls", "gopls", "rust_analyzer", "bashls", "jsonls", "yamlls", "html", "cssls", "dockerls" },
	automatic_enable = { exclude = { "ts_ls" } },
})

-- prolog_ls talks to SWI-Prolog's own `lsp_server` pack (not Mason-managed -
-- install it once from inside swipl: `swipl pack install lsp_server`, or
-- `?- pack_install(lsp_server).`). nvim-lspconfig ships the client config,
-- so enabling it is enough once the pack is installed and swipl is on PATH.
vim.lsp.enable("prolog_ls")

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
-- fzf-native needs a separate `make` on each platform; Telescope still works
-- with its built-in sorter until that optional native extension is built.
pcall(require("telescope").load_extension, "fzf")
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
require("nvim-treesitter.install").ensure_installed("bash", "c", "css", "dockerfile", "go", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python", "rust", "toml", "tsx", "typescript", "typst", "vim", "vimdoc", "yaml")

-- Typst does want core treesitter highlighting (much richer than the
-- built-in regex syntax), so switch it on for typst buffers. pcall covers the first
-- start, before the parser has finished installing.
vim.api.nvim_create_autocmd("FileType", {
	desc = "Treesitter highlighting for typst",
	pattern = { "sh", "c", "css", "dockerfile", "go", "html", "javascript", "json", "lua", "markdown", "python", "rust", "toml", "typescript", "typescriptreact", "typst", "vim", "yaml" },
	callback = function(args)
		pcall(vim.treesitter.start, args.buf, "typst")
	end,
})

-- render-markdown.nvim: turns raw markdown syntax into a rendered view
-- (styled headings, boxed tables, checkbox icons, highlighted code blocks)
-- directly in the buffer, dropping back to raw text on the cursor's line
-- so you can still edit it. Toggle with <leader>mr if you need raw text.
require("render-markdown").setup({})

-- Workaround: on Neovim 0.12 nightly builds, the #set-lang-from-info-string!
-- treesitter directive (nvim-treesitter, used to detect a fenced code
-- block's language e.g. ```lua so it can be injected/highlighted) can be
-- handed a list of nodes instead of a single TSNode. nvim-treesitter's
-- handler doesn't know about this yet and crashes calling node:range(),
-- which is the "attempt to call method 'range' (a nil value)" error in
-- query_predicates.lua that spams :messages when rendering markdown.
-- Re-register a defensive version that unwraps a list and skips instead
-- of erroring when it still can't get a node. Remove this once upstream
-- fixes it: https://github.com/nvim-treesitter/nvim-treesitter/issues/8636
do
	-- nvim-treesitter is an "opt" pack, so this file isn't required at
	-- startup - it only gets pulled in (and registers the buggy handler
	-- below) the first time a markdown buffer is actually parsed. Force
	-- that require now, at startup, so our override below is guaranteed
	-- to run *after* it and win. require() caches modules, so nothing
	-- later can trigger nvim-treesitter's version to register again.
	pcall(require, "nvim-treesitter.query_predicates")

	local ts_query = vim.treesitter.query
	local function first_node(v)
		if type(v) ~= "table" then
			return v
		end
		return v[1]
	end

	ts_query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
		local node = first_node(match[pred[2]])
		if not node then
			return
		end
		local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
		if not ok or not text or text == "" then
			return
		end
		local alias = text:lower()
		metadata["injection.language"] = vim.treesitter.language.get_lang(alias) or alias
	end, { force = true, all = false })
end

-- glance peeks definitions/references/implementations in a floating window
-- without moving your cursor away from where you were reading.
require("glance").setup({})

-- actions-preview shows a diff of what a code action will actually do
-- before you apply it (used by the <leader>ca keymap).
require("actions-preview").setup({})

-- conform runs dedicated formatter CLIs (install them via :Mason or your
-- system package manager, e.g. `brew install stylua prettier`).
require("conform").setup({
	-- Wraps SWI-Prolog's own formatter (ships in the `lsp_server` pack:
	-- `swipl pack install lsp_server`). Untested against conform's
	-- stdout-capture assumption - try `:ConformInfo` and a manual `:Format`
	-- on a .pl buffer before trusting format-on-save with it.
	formatters = {
		["clang-format"] = {
			-- Prefer a project's .clang-format when it exists, but default new C++
			-- projects to Google's C++ formatting rules.
			prepend_args = { "--fallback-style=Google" },
		},
		swipl_formatter = {
			command = "swipl",
			args = { "formatter", "$FILENAME" },
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		html = { "prettier" },
		scss = { "prettier" },
		go = { "gofumpt", "goimports" },
		rust = { "rustfmt" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		cuda = { "clang-format" },
		objc = { "clang-format" },
		objcpp = { "clang-format" },
		proto = { "clang-format" },
		cmake = { "cmake_format" },
		python = { "black" },
		java = { "google-java-format" },
		prolog = { "swipl_formatter" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback", -- fall back to the LSP formatter if no CLI formatter matches
	},
})

-- nvim-lint runs dedicated linter CLIs on save (install via :Mason).
local lint = require("lint")
lint.linters.cmakelint.cmd = vim.fn.executable("cmake-lint") == 1 and "cmake-lint" or "cmakelint"
lint.linters_by_ft = {
	c = { "cpplint" },
	cpp = { "cpplint" },
	cmake = { "cmakelint" },
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

-- typst-preview runs tinymist and serves a live preview to the browser.
-- On macOS, open_cmd opens it in a Safari window on the right half of the
-- screen (see stirlingdonaldson/typst_preview.lua).
require("typst-preview").setup({
	open_cmd = require("stirlingdonaldson.typst_preview").open_cmd(),
})

require("gitblame").setup({
	--Note how the `gitblame_` prefix is omitted in `setup`
	enabled = false,
})

require("stirlingdonaldson.vm_features").setup()

-- oil bg color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "OilDirIconPurple", { fg = "#9d79d6" })
