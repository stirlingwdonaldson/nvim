vim.g.mapleader = " "


-- general
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true})

-- oil
vim.keymap.set("n", "q", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { noremap = true, silent = true})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>F", builtin.live_grep, { desc = "Telescope live grep" })

-- formatting
vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true})

-- lazygit
vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { noremap = true, silent = true})

-- typst
local function ensure_tmux_pane_zoomed()
  -- Only run tmux logic when Neovim is inside a tmux session.
  if not vim.env.TMUX then
    return
  end

  -- Avoid toggling off zoom if the pane is already zoomed.
  local is_zoomed = vim.fn.system("tmux display-message -p '#{window_zoomed_flag}' 2>/dev/null")
  is_zoomed = is_zoomed:gsub("%s+", "")

  if is_zoomed ~= "1" then
    vim.fn.system("tmux resize-pane -Z")
  end
end

vim.keymap.set("n", "<leader>t", function()
  ensure_tmux_pane_zoomed()
  vim.cmd("TypstPreview")

end, { noremap = true, silent = true, desc = "Typst preview + layout" })
