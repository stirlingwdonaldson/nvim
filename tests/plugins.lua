-- Exercise representative plugin interfaces in a temporary directory.
local original_cwd = vim.fn.getcwd()
local project = vim.fn.tempname()
local function wait_for_filetype(filetype)
  return vim.wait(5000, function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == filetype then return true end
    end
    return false
  end, 50)
end
local function check()
  vim.fn.mkdir(project, "p")
  vim.fn.writefile({ "hello" }, project .. "/example.txt")
  vim.cmd.cd(vim.fn.fnameescape(project))
  vim.cmd("Oil " .. vim.fn.fnameescape(project))
  assert(wait_for_filetype("oil"), "Oil did not open")
  require("telescope.builtin").find_files({ cwd = project })
  assert(wait_for_filetype("TelescopePrompt"), "Telescope did not open")
  require("telescope.actions").close(vim.api.nvim_get_current_buf())
  vim.cmd("Neotree show")
  assert(wait_for_filetype("neo-tree"), "Neo-tree did not open")
  vim.wait(250, function() return false end, 50)
  vim.cmd("Neotree close")
  vim.wait(250, function() return false end, 50)
  print("Plugin interface checks passed")
end
local ok, err = xpcall(check, debug.traceback)
vim.cmd.cd(vim.fn.fnameescape(original_cwd))
vim.fn.delete(project, "rf")
if not ok then io.stderr:write(err .. "\n"); vim.cmd("cquit 1") end
