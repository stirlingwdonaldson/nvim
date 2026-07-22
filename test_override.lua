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

-- Clear columns in case it was already loaded
package.loaded["oil.columns"] = nil

require("oil").setup()
-- Create a mock entry to test the column renderer
local columns = require("oil.columns")
local icon_col = columns.get_column(nil, "icon") -- we need to fake adapter?
