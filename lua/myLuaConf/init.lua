-- Non-plugin config
require("myLuaConf.options")
require("myLuaConf.autocmds")
require("myLuaConf.keymaps")

-- Lazy-load plugins
-- require("myLuaConf.plugins")
require("lz.n").load("myLuaConf.plugins")
