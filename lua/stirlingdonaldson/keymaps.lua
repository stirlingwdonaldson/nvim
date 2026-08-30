vim.g.mapleader = " "

-- general
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true, desc = "Quit window" })
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true, desc = "Quit all (force)" })

-- oil (buffer-based file browser)
vim.keymap.set("n", "q", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true, silent = true, desc = "File explorer (Oil)" })

-- neo-tree (sidebar file tree, better for seeing a whole project's shape)
vim.keymap.set("n", "<leader>E", "<cmd>Neotree toggle<CR>", { noremap = true, silent = true, desc = "File tree (Neo-tree)" })

-- telescope
local telescope_builtin = require("telescope.builtin")
local telescope_large_layout = {
  layout_config = {
    width = 0.9,
    height = 0.9,
  },
}

vim.keymap.set("n", "<leader>f", function()
  telescope_builtin.find_files(telescope_large_layout)
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>F", function()
  telescope_builtin.live_grep(telescope_large_layout)
end, { desc = "Live grep" })

-- Telescope's built-in LSP pickers: these list every matching location
-- (e.g. an interface plus all of its implementations) instead of jumping
-- straight to the first/only result.
vim.keymap.set("n", "gd", telescope_builtin.lsp_definitions, { desc = "Goto definition (list)" })
vim.keymap.set("n", "gD", telescope_builtin.lsp_type_definitions, { desc = "Goto type definition (list)" })
vim.keymap.set("n", "gi", telescope_builtin.lsp_implementations, { desc = "Goto implementation (list)" })
vim.keymap.set("n", "gr", telescope_builtin.lsp_references, { desc = "Goto references (list)" })

-- fzf-lua: a second, faster fuzzy finder kept alongside telescope.
-- Grouped under its own <leader>z prefix so it doesn't collide with the
-- telescope bindings above.
vim.keymap.set("n", "<leader>zf", "<cmd>FzfLua files<CR>", { desc = "Files (fzf-lua)" })
vim.keymap.set("n", "<leader>zg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep (fzf-lua)" })
vim.keymap.set("n", "<leader>zb", "<cmd>FzfLua buffers<CR>", { desc = "Buffers (fzf-lua)" })

-- glance: peek definitions/references/implementations in a floating
-- window without leaving your current cursor position.
vim.keymap.set("n", "<leader>gd", "<cmd>Glance definitions<CR>", { desc = "Glance definitions" })
vim.keymap.set("n", "<leader>gr", "<cmd>Glance references<CR>", { desc = "Glance references" })
vim.keymap.set("n", "<leader>gy", "<cmd>Glance type_definitions<CR>", { desc = "Glance type definitions" })
vim.keymap.set("n", "<leader>gi", "<cmd>Glance implementations<CR>", { desc = "Glance implementations" })

-- outline / symbol navigation - handy for jumping around large,
-- namespace-heavy files (e.g. a big Java class).
vim.keymap.set("n", "<leader>oo", "<cmd>AerialToggle<CR>", { desc = "Toggle symbol outline" })
vim.keymap.set("n", "<leader>of", telescope_builtin.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ow", telescope_builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

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
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { noremap = true, silent = true, desc = "Buffer Diagnostics (Trouble)" })

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
  { "<leader>E", desc = "File tree (Neo-tree)" },
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
