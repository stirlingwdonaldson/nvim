-- Exercise real language-server initialization in a disposable project.
local original_cwd = vim.fn.getcwd()
local project = vim.fn.tempname()
local project_name = vim.fn.fnamemodify(project, ":t")
local function check()
  vim.fn.mkdir(project .. "/.git", "p")
  vim.fn.writefile({ "[project]", 'name = "nvim-smoke"', 'version = "0.0.1"' }, project .. "/pyproject.toml")
  vim.fn.writefile({ ":- module(test, [])." }, project .. "/pack.pl")
  vim.fn.writefile({ "x = 1" }, project .. "/example.py")
  vim.fn.writefile({ "parent(a, b)." }, project .. "/example.pl")
  vim.fn.writefile({ "cmake_minimum_required(VERSION 3.15)", "project(Smoke)" }, project .. "/CMakeLists.txt")
  vim.fn.writefile({ "class Hello {}" }, project .. "/Hello.java")
  vim.cmd.cd(vim.fn.fnameescape(project))
  for _, spec in ipairs({
    { "example.py", "pyright" },
    { "example.pl", "prolog_ls" },
    { "CMakeLists.txt", "cmake" },
    { "Hello.java", "jdtls" },
  }) do
    vim.cmd.edit(vim.fn.fnameescape(project .. "/" .. spec[1]))
    local buf = vim.api.nvim_get_current_buf()
    local ready = vim.wait(45000, function()
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = spec[2] })) do
        if client.initialized then return true end
      end
      return false
    end, 100)
    assert(ready, spec[2] .. " did not initialize for " .. spec[1])
    print(spec[2] .. " initialized")
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do client:stop() end
  end
end
local ok, err = xpcall(check, debug.traceback)
for _, client in ipairs(vim.lsp.get_clients()) do client:stop(true) end
vim.cmd.cd(vim.fn.fnameescape(original_cwd))
vim.fn.delete(project, "rf")
vim.fn.delete(vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name, "rf")
if not ok then io.stderr:write(err .. "\n"); vim.cmd("cquit 1") end
print("Language-server checks passed")
