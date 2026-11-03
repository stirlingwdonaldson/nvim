-- Basic Options
vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
-- A remote Rex terminal can forward OSC 52 clipboard operations to its client.
if vim.fn.has("linux") == 1 and (vim.env.SSH_CONNECTION or vim.env.REX_SESSION) then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
		paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
	}
end
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.expandtab = true -- Turn tabs into spaces
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.wrap = true -- Disable line wrap
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search has capitals
vim.opt.termguicolors = true -- Enable 24-bit RGB color
vim.opt.splitright = true -- Vertical splits to the right
vim.opt.splitbelow = true -- Horizontal splits to the bottom
vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above/below cursor
vim.opt.signcolumn = "yes" -- Always show signcolumn
vim.opt.fillchars = { eob = " " }
vim.o.background = "dark" -- or "light"

vim.o.cmdheight = 0

-- Appearance
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

vim.diagnostic.config({
	-- virtual_text is off because tiny-inline-diagnostic.nvim (see plugins.lua)
	-- renders inline diagnostics itself; leaving both on would draw them twice.
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "if_many",
		border = "rounded",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Use Google-style C++ editing defaults",
	pattern = { "c", "cpp", "cuda", "objc", "objcpp", "proto" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
		vim.opt_local.textwidth = 80
		vim.opt_local.colorcolumn = "80"
	end,
})

vim.cmd([[colorscheme carbonfox]])
