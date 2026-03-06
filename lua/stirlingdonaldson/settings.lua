-- Editor behavior
vim.o.clipboard = "unnamedplus"
vim.o.smartindent = true
vim.wo.relativenumber = true

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 3
vim.o.softtabstop = 3
vim.o.tabstop = 3

-- UI
vim.g.have_nerd_font = true
vim.o.cmdheight = 0
vim.o.laststatus = 3
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.cmd("colorscheme eigengrau")



-- ██  ██ █████▄ █████▄ █▀▀█ ██████ ██▀▀▀▀    █████▄ ██▀▀▀▀ █████▄ ▄████▄
-- ██  ██ ██▄▄█▀ ██  ██ ████   ██   █▀▀▀      ██▄▄█▀ █▀▀▀   ██▄▄█▀ ██  ██
-- ▀████▀ ██     █████▀ █  █   ██   ██████    ██ ▀██ ██████ ██     ▀████▀

vim.api.nvim_create_user_command("EigengrauUpdate", function()

   -- update cache & fetch head
	local dir = vim.fn.stdpath("data") .. "/site/pack/core/start/eigengrau"
	vim.fn.system("git -C " .. dir .. " fetch origin")
	vim.fn.system("git -C " .. dir .. " checkout origin/main")

	-- Update the lock file rev to the new HEAD
	local rev = vim.trim(vim.fn.system("git -C " .. dir .. " rev-parse --short HEAD"))
	local lock_path = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"
	local lock = vim.fn.readfile(lock_path)
	local text = table.concat(lock, "\n")
	text = text:gsub(
		'("eigengrau":%s*{%s*"rev":%s*").-(")',
		"%1" .. rev .. "%2"
	)
	vim.fn.writefile(vim.split(text, "\n"), lock_path)

	-- Reload the colorscheme
	package.loaded["eigengrau"] = nil
	package.loaded["eigengrau.palette"] = nil
	vim.cmd("colorscheme eigengrau")
	vim.notify("Eigengrau updated to " .. rev .. " and reloaded")
end, {})

vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		prefix = "●",
		source = "if_many",
		severity = vim.diagnostic.severity.ERROR,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
