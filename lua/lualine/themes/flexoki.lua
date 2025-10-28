-- Adapted from
-- https://github.com/cpplain/flexoki-lualine.nvim/tree/main
-- MIT license

-- Flexoki colors
local c = require("flexoki").c

return {
	normal = {
		a = { bg = c.blue, fg = c.bg },
		b = { bg = c.ui, fg = c.blue },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = c.ui, fg = c.blue },
		z = { bg = c.blue, fg = c.bg },
	},
	insert = {
		a = { bg = c.green, fg = c.bg },
		b = { bg = c.ui, fg = c.green },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = c.ui, fg = c.green },
		z = { bg = c.green, fg = c.bg },
	},
	visual = {
		a = { bg = c.magenta, fg = c.bg },
		b = { bg = c.ui, fg = c.magenta },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = c.ui, fg = c.magenta },
		z = { bg = c.magenta, fg = c.bg },
	},
	replace = {
		a = { bg = c.red, fg = c.bg },
		b = { bg = c.ui, fg = c.red },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = c.ui, fg = c.red },
		z = { bg = c.red, fg = c.bg },
	},
	command = {
		a = { bg = c.orange, fg = c.bg },
		b = { bg = c.ui, fg = c.orange },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = c.ui, fg = c.orange },
		z = { bg = c.orange, fg = c.bg },
	},
	terminal = {
		a = { bg = c.green, fg = c.bg },
		b = { bg = c.ui, fg = c.green },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = c.ui, fg = c.green },
		z = { bg = c.green, fg = c.bg },
	},
	inactive = {
		a = { bg = "NONE", fg = c.tx2 },
		b = { bg = "NONE", fg = c.tx2 },
		c = { bg = "NONE", fg = c.tx2 },
		x = { bg = "NONE", fg = c.tx2 },
		y = { bg = "NONE", fg = c.tx2 },
		z = { bg = "NONE", fg = c.tx2 },
	},
}
