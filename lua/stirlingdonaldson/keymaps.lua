vim.g.mapleader = " "

-- general
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>Q", ":qa!<CR>", { noremap = true, silent = true})

-- oil
vim.keymap.set("n", "q", "<cmd>close<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { noremap = true, silent = true})

-- telescope
local builtin = require('telescope.builtin')
local telescope_large_layout = {
  layout_config = {
    width = 0.9,
    height = 0.9,
  },
}

vim.keymap.set("n", "<leader>f", function()
  builtin.find_files(telescope_large_layout)
end, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>F", function()
  builtin.live_grep(telescope_large_layout)
end, { desc = "Telescope live grep" })

-- formatting
vim.keymap.set("n", "<leader>lf", "<CMD>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true})

local function jump_to_definition_target()
  local current_uri = vim.uri_from_bufnr(0)

  local function is_import_location(location)
    local uri = location.uri or location.targetUri
    if uri ~= current_uri then
      return false
    end

    local range = location.range or location.targetSelectionRange or location.targetRange
    if not range then
      return false
    end

    local line = vim.api.nvim_buf_get_lines(0, range.start.line, range.start.line + 1, false)[1] or ""
    return line:match('^%s*import[%s{"]') ~= nil or line:match("%sfrom%s+['\"]") ~= nil
  end

  local function normalize_location(location)
    if location.targetUri then
      return {
        uri = location.targetUri,
        range = location.targetSelectionRange or location.targetRange,
      }
    end

    return location
  end

  local function request_locations(method)
    local params = vim.lsp.util.make_position_params(0, "utf-16")
    local responses = vim.lsp.buf_request_sync(0, method, params, 1000) or {}
    local locations = {}

    for client_id, response in pairs(responses) do
      local client = vim.lsp.get_client_by_id(client_id)
      local result = response.result
      if result then
        if result.uri or result.targetUri then
          table.insert(locations, { location = result, client = client })
        else
          for _, location in ipairs(result) do
            table.insert(locations, { location = location, client = client })
          end
        end
      end
    end

    return locations
  end

  local function request_typescript_source_locations()
    local locations = {}

    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
      if client.name == "vtsls" or client.name == "ts_ls" then
        local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
        local response = client:request_sync("workspace/executeCommand", {
          command = "_typescript.goToSourceDefinition",
          arguments = { vim.api.nvim_buf_get_name(0), params.position },
        }, 1000, 0)

        local result = response and response.result
        if result then
          if result.uri or result.targetUri then
            table.insert(locations, { location = result, client = client })
          else
            for _, location in ipairs(result) do
              table.insert(locations, { location = location, client = client })
            end
          end
        end
      end
    end

    return locations
  end

  local definition_locations = request_locations("textDocument/definition")

  for _, entry in ipairs(definition_locations) do
    if not is_import_location(entry.location) then
      vim.lsp.util.jump_to_location(normalize_location(entry.location), entry.client and entry.client.offset_encoding or "utf-16", true)
      return
    end
  end

  for _, entry in ipairs(request_typescript_source_locations()) do
    if not is_import_location(entry.location) then
      vim.lsp.util.jump_to_location(normalize_location(entry.location), entry.client and entry.client.offset_encoding or "utf-16", true)
      return
    end
  end

  for _, entry in ipairs(request_locations("textDocument/implementation")) do
    if not is_import_location(entry.location) then
      vim.lsp.util.jump_to_location(normalize_location(entry.location), entry.client and entry.client.offset_encoding or "utf-16", true)
      return
    end
  end

  if definition_locations[1] then
    local entry = definition_locations[1]
    vim.lsp.util.jump_to_location(normalize_location(entry.location), entry.client and entry.client.offset_encoding or "utf-16", true)
    return
  end

  vim.notify("No definition found", vim.log.levels.INFO)
end

vim.keymap.set("n", "gd", jump_to_definition_target, { desc = "Go to definition target" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Project-wide search and replace (word under cursor)
vim.keymap.set("n", "<leader>rw", function()
  local old_word = vim.fn.expand('<cword>')
  
  if old_word == "" then
    vim.notify("No word under cursor.", vim.log.levels.WARN)
    return
  end
  
  local new_word = vim.fn.input("Replace '" .. old_word .. "' across project with: ")
  if new_word == nil or new_word == "" then
    return
  end
  
  -- Execute vimgrep for ts and tsx files silently
  vim.cmd("silent! vimgrep /" .. old_word .. "/ **/*.ts **/*.tsx")
  
  -- Open quickfix list to show the matches
  vim.cmd("copen")
  
  -- Execute the replacement across the quickfix list
  -- (The 'c' flag will ask you to confirm each replacement (y/n/a/q). Remove 'c' if you want it fully automatic)
  vim.cmd("cdo s/" .. old_word .. "/" .. new_word .. "/gc | update")
end, { desc = "Replace cursor word across TS/TSX files" })

-- lazygit
vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { noremap = true, silent = true})

-- trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { noremap = true, silent = true, desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { noremap = true, silent = true, desc = "Buffer Diagnostics (Trouble)" })

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

end, { noremap = true, silent = true, desc = "Typst preview + Layout" })
