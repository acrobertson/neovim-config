-- Non-plugin config
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- Lazy-load plugins
require("lz.n").load("config.plugins")
