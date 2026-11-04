-- Run after installing dependencies; exercises real parsers and key config.
local function check()
  assert(vim.g.mapleader == " ", "leader should be Space")
  assert(vim.fn.maparg("<Space>f", "n") ~= "", "file finder mapping missing")
  assert(vim.fn.maparg("<Space>e", "n") ~= "", "Oil mapping missing")
  assert(not package.loaded["fzf-lua"], "fzf-lua loaded before first use")
  assert(type(require("fzf-lua").files) == "function", "fzf-lua picker missing")
  assert(vim.wait(20000, function() return require("blink.cmp.fuzzy").implementation_type == "rust" end, 100), "blink native matcher did not load")
  assert(vim.lsp.config["*"].capabilities.textDocument.completion.completionItem.snippetSupport, "completion capabilities missing")
  for _, language in ipairs(require("stirlingdonaldson.languages").parsers) do
    local ok, loaded = pcall(vim.treesitter.language.add, language)
    assert(ok and loaded ~= false, "parser could not load: " .. language)
  end
  local registry = require("mason-registry")
  registry.refresh()
  for _, name in ipairs(require("stirlingdonaldson.languages").mason_packages) do
    assert(registry.get_package(name):is_installed(), "Mason package missing: " .. name)
  end
  for filetype, language in pairs({ lua = "lua", python = "python", typescript = "typescript" }) do
    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })
    assert(vim.wait(2000, function() return vim.treesitter.highlighter.active[buf] ~= nil end, 20), "highlighting missing for " .. filetype)
    assert(vim.treesitter.get_parser(buf):lang() == language, "wrong parser for " .. filetype)
    vim.api.nvim_buf_delete(buf, { force = true })
  end
  for _, tool in ipairs({ "fzf", "rg", "lazygit", "java", "swipl", "rustfmt", "prettier", "black", "ruff", "clang-format", "shfmt" }) do
    assert(vim.fn.executable(tool) == 1, "missing executable: " .. tool)
  end
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'const answer={value:42}' })
  vim.api.nvim_set_option_value("filetype", "javascript", { buf = buf })
  local formatted = require("conform").format({ bufnr = buf, async = false, lsp_format = "never" })
  assert(formatted, "Prettier did not run")
  assert(vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]:match("const answer ="), "unexpected Prettier output")
  vim.api.nvim_buf_delete(buf, { force = true })
  local prolog_path = vim.fn.tempname() .. ".pl"
  vim.fn.writefile({ "original(a,b)." }, prolog_path)
  local prolog = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(prolog, prolog_path)
  vim.api.nvim_buf_set_lines(prolog, 0, -1, false, { "parent( a,b)." })
  vim.api.nvim_set_option_value("filetype", "prolog", { buf = prolog })
  local prolog_formatted = require("conform").format({ bufnr = prolog, async = false, timeout_ms = 5000, lsp_format = "never" })
  assert(prolog_formatted, "Prolog formatter did not run")
  assert(vim.api.nvim_buf_get_lines(prolog, 0, 1, false)[1] == "parent( a, b).", "unsaved Prolog buffer was not formatted")
  assert(vim.fn.readfile(prolog_path)[1] == "original(a,b).", "Prolog formatter modified the original file")
  vim.api.nvim_buf_delete(prolog, { force = true })
  vim.fn.delete(prolog_path)
  print("Neovim smoke checks passed")
end
local ok, err = xpcall(check, debug.traceback)
if not ok then io.stderr:write(err .. "\n"); vim.cmd("cquit 1") end
