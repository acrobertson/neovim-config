_G.Config = require("config.util")

vim.cmd.colorscheme("flexoki")

-- Non-plugin config
require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lsp")

-- Lazy-load plugins
require("lz.n").load("config.plugins")
