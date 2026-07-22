local util = require("oil.util")
local original_get_icon_provider = util.get_icon_provider
util.get_icon_provider = function(...)
  local orig = original_get_icon_provider(...)
  return function(type, name, conf)
    local icon, hl = orig(type, name, conf)
    if type == "directory" and name:match("^_") then
      hl = "OilDirIconPurple"
    end
    return icon, hl
  end
end

require("oil").setup()
-- Trigger column rendering by loading oil
local cols = require("oil.columns")
print("OK")
