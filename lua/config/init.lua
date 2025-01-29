_G.Config = require("config.util")

-- Non-plugin config
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- Lazy-load plugins
require("lz.n").load("config.plugins")
require('lzn-auto-require').enable()
