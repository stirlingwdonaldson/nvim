vim.g.mapleader = " "

local opts = { noremap = true, silent = true }
local map = vim.keymap.set
local function comment_title(size)
	package.loaded["stirlingdonaldson.comment_titles"] = nil
	require("stirlingdonaldson.comment_titles").to_title(size)
end

-- General
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":wqa<CR>", opts)

-- File explorer and search
map("n", "<C-F>", "<CMD>Open .<CR>", opts)
map("n", "<leader>e", "<CMD>Oil<CR>", opts)
map("n", "<leader>f", "<CMD>Telescope find_files<CR>", opts)

-- LSP and formatting
map("n", "<leader>lf", function()
	require("conform").format({
		async = false,
		lsp_fallback = true,
	})
end, opts)

map("n", "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", opts)
map("n", "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", opts)

-- screen

map({ "n" }, "<leader>%", "<CMD>vsplit<CR>", opts)
map({ "n" }, '<leader>"', "<CMD>split<CR>", opts)

-- Version control
map("n", "<leader>lg", "<CMD>LazyGit<CR>", opts)

-- Typst
map("n", "<leader>t", "<CMD>TypstPreview<CR>", opts)
map("n", "<leader>c", function()
	local input = vim.fn.expand("%:p")
	local output = vim.fn.expand("%:p:r") .. ".pdf"
	vim.cmd("write")
	vim.fn.jobstart({ "typst", "compile", input, output }, {
		on_exit = function(_, code)
			if code == 0 then
				vim.schedule(function()
					vim.notify("Compiled: " .. output, vim.log.levels.INFO)
				end)
			else
				vim.schedule(function()
					vim.notify("Typst compile failed", vim.log.levels.ERROR)
				end)
			end
		end,
	})
end, opts)

-- Command-line convenience
map({ "n", "v", "x" }, ";", ":", opts)
-- map({ "n" }, "<leader><leader>", ":")

-- Comment titles
map("n", "<leader>mt", function()
	comment_title("small")
end, opts)
map("n", "<leader>mts", function()
	comment_title("small")
end, opts)
map("n", "<leader>mtl", function()
	comment_title("large")
end, opts)

vim.keymap.set("n", "<leader>pa", function()
  vim.fn.jobstart({ "open", vim.fn.expand("%:p") }, { detach = true })
end)

vim.keymap.set("n", "<leader>F", "<cmd>silent !open -R %:p<CR>")
