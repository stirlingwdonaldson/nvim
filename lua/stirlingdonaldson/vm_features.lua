-- Features retained from the VM's previous Neovim configuration.
local M = {}

function M.setup()
	require("nvim-autopairs").setup()
	require("ts-comments").setup()
	require("nvim-surround").setup()
	require("persistence").setup()
	require("flash").setup()
	require("todo-comments").setup()
	require("lualine").setup({ options = { section_separators = "", component_separators = "" } })
	require("bufferline").setup({ options = { diagnostics = "nvim_lsp", show_close_icon = false } })
	require("ibl").setup({ indent = { char = "│" } })
	require("gitsigns").setup({
		on_attach = function(buf)
			local gs = require("gitsigns")
			local function map(key, action, description)
				vim.keymap.set("n", key, action, { buffer = buf, desc = description })
			end
			map("]c", function() gs.nav_hunk("next") end, "Next hunk")
			map("[c", function() gs.nav_hunk("prev") end, "Previous hunk")
			map("<leader>hs", gs.stage_hunk, "Stage hunk")
			map("<leader>hr", gs.reset_hunk, "Reset hunk")
			map("<leader>hS", gs.stage_buffer, "Stage buffer")
			map("<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
			map("<leader>hp", gs.preview_hunk, "Preview hunk")
			map("<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
			map("<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
			map("<leader>td", gs.toggle_deleted, "Toggle deleted")
		end,
	})
end

return M
