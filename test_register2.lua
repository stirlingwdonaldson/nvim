require("oil").setup()
local columns = require("oil.columns")
-- Re-register icon
local has_devicons, devicons = pcall(require, "nvim-web-devicons")
columns.register("icon", {
  render = function(entry, conf)
    local type = entry[1] -- field type?
    local name = entry[2] -- field name?
    print(type, name)
    return { "X", "MyHl" }
  end,
  parse = function(line, conf)
    return line:match("^(%S+)%s+(.*)$")
  end,
})
print("Success")
