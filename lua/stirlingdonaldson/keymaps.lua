vim.g.mapleader = " "

-- general
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit window" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true, desc = "Quit all (force)" })

-- Shared VM navigation and editing shortcuts.
local map = vim.keymap.set
map("i", "jk", "<Esc>")
map("i", "kj", "<Esc>")
for _, direction in ipairs({ "h", "j", "k", "l" }) do
	map("n", "<C-" .. direction .. ">", "<C-w>" .. direction, { desc = "Move between windows" })
end
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<S-l>", ":bnext<CR>")
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "p", '"_dP')
map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
map("n", "<leader>ss", function() require("persistence").load({ last = true }) end, { desc = "Restore session" })
map("n", "<leader>sd", function() require("persistence").stop() end, { desc = "Stop saving session" })
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous TODO" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>")
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>")
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "<leader>ds", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle inlay hints" })

-- oil (buffer-based file browser)
vim.keymap.set("n", "q", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true, silent = true, desc = "File explorer (Oil)" })

-- fzf-lua pickers preserve the shared search and navigation shortcuts.
local function picker(name)
  return function() require("fzf-lua")[name]() end
end
map("n", "<leader>f", picker("files"), { desc = "Find files" })
map("n", "<leader>F", picker("live_grep"), { desc = "Live grep" })
map("n", "<leader>fb", picker("buffers"), { desc = "Buffers" })
map("n", "<leader>fh", picker("helptags"), { desc = "Help tags" })
map("n", "<leader>fr", picker("oldfiles"), { desc = "Recent files" })
map("n", "<leader>gc", picker("git_commits"), { desc = "Git commits" })
map("n", "<leader>gs", picker("git_status"), { desc = "Git status" })
map("n", "gd", picker("lsp_definitions"), { desc = "Goto definition (list)" })
map("n", "gD", picker("lsp_typedefs"), { desc = "Goto type definition (list)" })
map("n", "gi", picker("lsp_implementations"), { desc = "Goto implementation (list)" })
map("n", "gr", picker("lsp_references"), { desc = "Goto references (list)" })
map("n", "<leader>zf", picker("files"), { desc = "Files" })
map("n", "<leader>zg", picker("live_grep"), { desc = "Live grep" })
map("n", "<leader>zb", picker("buffers"), { desc = "Buffers" })

-- glance: peek definitions/references/implementations in a floating
-- window without leaving your current cursor position.
vim.keymap.set("n", "<leader>gd", "<cmd>Glance definitions<CR>", { desc = "Glance definitions" })
vim.keymap.set("n", "<leader>gr", "<cmd>Glance references<CR>", { desc = "Glance references" })
vim.keymap.set("n", "<leader>gy", "<cmd>Glance type_definitions<CR>", { desc = "Glance type definitions" })
vim.keymap.set("n", "<leader>gi", "<cmd>Glance implementations<CR>", { desc = "Glance implementations" })

-- outline / symbol navigation - handy for jumping around large,
-- namespace-heavy files (e.g. a big Java class).
vim.keymap.set("n", "<leader>oo", "<cmd>AerialToggle<CR>", { desc = "Toggle symbol outline" })
vim.keymap.set("n", "<leader>of", picker("lsp_document_symbols"), { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ow", picker("lsp_live_workspace_symbols"), { desc = "Workspace symbols" })

-- formatting: conform runs a dedicated formatter CLI for the filetype,
-- falling back to the LSP's own formatter if none is configured.
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { noremap = true, silent = true, desc = "Format buffer" })

-- code actions: shows a preview of what each action will change before
-- you commit to applying it.
vim.keymap.set({ "n", "v" }, "<leader>ca", require("actions-preview").code_actions, { desc = "Code actions (preview)" })

-- lazygit
vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { noremap = true, silent = true, desc = "LazyGit" })

-- trouble
vim.keymap.set(
	"n",
	"<leader>xx",
	"<cmd>Trouble diagnostics toggle<CR>",
	{ noremap = true, silent = true, desc = "Diagnostics (Trouble)" }
)
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ noremap = true, silent = true, desc = "Buffer Diagnostics (Trouble)" }
)

-- noice: rendered cmdline/messages/LSP popups
vim.keymap.set("n", "<leader>nh", "<cmd>Noice history<CR>", { desc = "Message history (Noice)" })
vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<CR>", { desc = "Dismiss messages (Noice)" })

-- gen.nvim: describe what you want in plain English, get back the command
-- to run, generated locally by Ollama - nothing sent over the network.
vim.keymap.set("n", "<leader>ai", "<cmd>Gen Command_Lookup<CR>", { desc = "Ask for a command (local LLM)" })

-- render-markdown: flip between the rendered view and raw markdown text.
vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle rendered markdown" })

-- which-key group labels: names the prefixes above so the popup shows
-- "Find", "Glance", etc. instead of a raw, unlabelled list of keys.
require("which-key").add({
	{ "<leader>e", desc = "File explorer (Oil)" },
	{ "<leader>f", desc = "Find files" },
	{ "<leader>F", desc = "Live grep" },
	{ "<leader>g", group = "Glance (peek)" },
	{ "<leader>l", group = "LSP / Git tools" },
	{ "<leader>n", group = "Noice" },
	{ "<leader>o", group = "Outline / Symbols" },
	{ "<leader>q", desc = "Quit window" },
	{ "<leader>Q", desc = "Quit all (force)" },
	{ "<leader>ai", desc = "Ask for a command (local LLM)" },
	{ "<leader>m", group = "Markdown" },
	{ "<leader>w", desc = "Save file" },
	{ "<leader>x", group = "Diagnostics (Trouble)" },
	{ "<leader>z", group = "Fuzzy find (fzf-lua)" },
})
