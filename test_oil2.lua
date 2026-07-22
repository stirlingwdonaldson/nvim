package.loaded["oil"] = nil
package.loaded["oil.columns"] = nil
package.loaded["oil.util"] = nil

local util = require("oil.util")
local original_get_icon_provider = util.get_icon_provider
util.get_icon_provider = function()
  local orig_provider = original_get_icon_provider()
  return function(type, name, conf)
    local icon, hl = orig_provider(type, name, conf)
    if type == "directory" and name:sub(1, 1) == "_" then
      hl = "OilDirIconPurple"
    end
    return icon, hl
  end
end

require("oil").setup()
local cols = require("oil.columns")
-- see if icon column is registered
print(cols.get_supported_columns()["icon"] ~= nil)
