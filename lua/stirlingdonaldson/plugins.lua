vim.pack.add({
	-- general dependencies
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },
	{ src = "https://github.com/nvim-lua/plenary.nvim.git" },

	-- lsp plugins
	{ src = "https://github.com/mason-org/mason.nvim.git" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim.git" },
	{ src = "https://github.com/neovim/nvim-lspconfig.git" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls.git" },
	{ src = "https://github.com/saghen/blink.cmp.git", version = "v1.10.2" },
	{ src = "https://github.com/rafamadriz/friendly-snippets.git" },

	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim.git" },
	{ src = "https://github.com/stevearc/oil.nvim.git" },
	{ src = "https://github.com/junegunn/fzf.vim.git" },
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" },
  { src = "https://github.com/folke/trouble.nvim.git"},

	-- documents
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim.git" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim.git" },

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
    providers = {
      snippets = {
        opts = {
          search_paths = { vim.fn.stdpath("config") .. "/snippets" },
        },
      },
    },
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

require("typst-preview").setup({
	-- Route preview URL through our script so we can manage window layout.
	open_cmd = vim.fn.stdpath("config") .. "/scripts/typst_preview_layout.sh '%s'",
})

-- oil bg color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "OilDirIconPurple", { fg = "#9d79d6" })
