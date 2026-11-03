vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Optional per-machine tools installed outside the configuration repository.
local tools_bin = vim.fn.stdpath("data") .. "-deps/node_modules/.bin"
if vim.fn.isdirectory(tools_bin) == 1 then
  vim.env.PATH = tools_bin .. (vim.fn.has("win32") == 1 and ";" or ":") .. vim.env.PATH
end
require("stirlingdonaldson.plugins")
require("stirlingdonaldson.keymaps")
require("stirlingdonaldson.settings")
