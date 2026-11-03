-- Start a temporary Typst preview without opening a browser.
local path = vim.fn.tempname() .. ".typ"
local config = require("typst-preview.config")
local servers = require("typst-preview.servers")
local previous_open = config.opts.open_cmd
local function check()
  local fetch = require("typst-preview.fetch")
  for _, bin in pairs(fetch.bins_to_fetch()) do
    assert(config.opts.dependencies_bin[bin.name] or fetch.up_to_date(bin), "missing Typst dependency: " .. bin.name)
  end
  vim.fn.writefile({ "= Preview test", "Hello, world." }, path)
  path = assert(vim.uv.fs_realpath(path))
  config.opts.open_cmd = "true %s"
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.cmd("TypstPreview")
  local main = config.opts.get_main_file(path)
  local ready = vim.wait(30000, function()
    local active = servers.get(main)
    return active and active.document and active.document.link ~= nil
  end, 100)
  assert(ready, "Typst preview server did not start")
  local url = "http://" .. servers.get(main).document.link
  local result = vim.system({ "curl", "-fsS", "--max-time", "5", url }, { text = true }):wait()
  assert(result.code == 0 and #result.stdout > 0, "Typst preview did not serve a page")
  vim.wait(200, function() return false end, 50)
  print("Typst preview server passed")
end
local ok, err = xpcall(check, debug.traceback)
servers.remove_all()
config.opts.open_cmd = previous_open
vim.fn.delete(path)
if not ok then io.stderr:write(err .. "\n"); vim.cmd("cquit 1") end
