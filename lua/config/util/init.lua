---@class config.util
---@field lsp config.util.lsp
---@field ui config.util.ui
local M = {}

setmetatable(M, {
	__index = function(t, k)
		t[k] = require("config.util." .. k)
		return t[k]
	end,
})

return M
