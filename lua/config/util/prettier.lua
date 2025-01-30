---@class config.util.prettier
local M = {}

local conform_util = require("conform.util")

M.builtin_filetypes = {
	"css",
	"graphql",
	"handlebars",
	"html",
	"javascript",
	"javascriptreact",
	"json",
	"jsonc",
	"less",
	"markdown",
	"markdown.mdx",
	"scss",
	"typescript",
	"typescriptreact",
	"vue",
	"yaml",
}

--- Gets the Prettier executable from `node_modules`
---@param config conform.JobFormatterConfig
---@param ctx conform.Context
function M.get_cmd(config, ctconfig, ctx)
	local command = conform_util.from_node_modules("prettier")
	return command(config, ctx)
end

--- Checks if a Prettier config file exists for the given context
---@param config conform.JobFormatterConfig
---@param ctx conform.Context
function M.has_config(config, ctx)
	local command = conform_util.from_node_modules("prettier")
	local cmd = command(config, ctx)
	vim.fn.system({ cmd, "--find-config-path", ctx.filename })
	return vim.v.shell_error == 0
end

--- Checks if a parser can be inferred for the given context:
--- * If the filetype is in the supported list, return true
--- * Otherwise, check if a parser can be inferred
---@param config conform.JobFormatterConfig
---@param ctx conform.Context
function M.has_parser(config, ctx)
	local ft = vim.bo[ctx.buf].filetype --[[@as string]]
	-- default filetypes are always supported
	if vim.tbl_contains(M.builtin_filetypes, ft) then
		return true
	end
	-- otherwise, check if a parser can be inferred
	local command = conform_util.from_node_modules("prettier")
	local cmd = command(config, ctx)
	local ret = vim.fn.system({ cmd, "--file-info", ctx.filename })
	---@type boolean, string?
	local ok, parser = pcall(function()
		return vim.fn.json_decode(ret).inferredParser
	end)
	return ok and parser and parser ~= vim.NIL
end

M.has_config = Config.memoize(M.has_config)
M.has_parser = Config.memoize(M.has_parser)

return M
