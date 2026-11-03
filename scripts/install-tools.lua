-- Invoked by install-tools.sh with the normal configuration loaded.
local registry = require("mason-registry")
registry.refresh()
local missing = {}
for _, name in ipairs(require("stirlingdonaldson.languages").mason_packages) do
  local ok, package = pcall(registry.get_package, name)
  if not ok then error("Mason package not found: " .. name) end
  if not package:is_installed() then table.insert(missing, name) end
end
if #missing > 0 then vim.cmd("MasonInstall " .. table.concat(missing, " ")) end
require("nvim-treesitter.install").ensure_installed_sync(require("stirlingdonaldson.languages").parsers)
for _, language in ipairs(require("stirlingdonaldson.languages").parsers) do
  local ok, loaded = pcall(vim.treesitter.language.add, language)
  assert(ok and loaded ~= false, "Parser could not load: " .. language)
end
for _, name in ipairs(require("stirlingdonaldson.languages").mason_packages) do
  assert(registry.get_package(name):is_installed(), "Mason package not installed: " .. name)
end
print("Configured Mason packages and Tree-sitter parsers are installed.")
