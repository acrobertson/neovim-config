local M = {}

---@class LSPKeymapSpec
---@field [1] string lhs
---@field [2]? string|fun() rhs
---@field desc string
---@field mode? string|string[]
---@field has? string|string[]
---@field cond? fun():boolean

---@class LSPKeymap
---@field lhs string lhs
---@field rhs? string|fun() rhs
---@field mode? string
---@field desc string
---@field id string
---@field name string
---@field has? string|string[]
---@field cond? fun():boolean

---@type LSPKeymapSpec[]
M._keys = {
	{ "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
	{ "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
	{ "gr", vim.lsp.buf.references, desc = "References", nowait = true },
	{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
	{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
	{
		"K",
		function()
			return vim.lsp.buf.hover()
		end,
		desc = "Hover",
	},
	{
		"gK",
		function()
			return vim.lsp.buf.signature_help()
		end,
		desc = "Signature Help",
		has = "signatureHelp",
	},
	{
		"<c-k>",
		function()
			return vim.lsp.buf.signature_help()
		end,
		mode = "i",
		desc = "Signature Help",
		has = "signatureHelp",
	},
	{
		"<leader>ca",
		vim.lsp.buf.code_action,
		desc = "Code Action",
		mode = { "n", "v" },
		has = "codeAction",
	},
	{
		"<leader>cc",
		vim.lsp.codelens.run,
		desc = "Run Codelens",
		mode = { "n", "v" },
		has = "codeLens",
	},
	{
		"<leader>cC",
		vim.lsp.codelens.refresh,
		desc = "Refresh & Display Codelens",
		mode = { "n" },
		has = "codeLens",
	},
	{
		"<leader>cR",
		function()
			Snacks.rename.rename_file()
		end,
		desc = "Rename File",
		mode = { "n" },
		has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
	},
	{ "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
	{ "<leader>cA", Config.lsp.action.source, desc = "Source Action", has = "codeAction" },
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		has = "documentHighlight",
		desc = "Next Reference",
		cond = function()
			return Snacks.words.is_enabled()
		end,
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		has = "documentHighlight",
		desc = "Prev Reference",
		cond = function()
			return Snacks.words.is_enabled()
		end,
	},
	{
		"<a-n>",
		function()
			Snacks.words.jump(vim.v.count1, true)
		end,
		has = "documentHighlight",
		desc = "Next Reference",
		cond = function()
			return Snacks.words.is_enabled()
		end,
	},
	{
		"<a-p>",
		function()
			Snacks.words.jump(-vim.v.count1, true)
		end,
		has = "documentHighlight",
		desc = "Prev Reference",
		cond = function()
			return Snacks.words.is_enabled()
		end,
	},
	{
		"<leader>ss",
		function()
			---@diagnostic disable-next-line: missing-fields
			Snacks.picker.lsp_symbols({ filter = Config.lsp.kind_filter })
		end,
		desc = "LSP Symbols",
		has = "documentSymbol",
	},
	{
		"<leader>sS",
		function()
			---@diagnostic disable-next-line: missing-fields
			Snacks.picker.lsp_workspace_symbols({ filter = Config.lsp.kind_filter })
		end,
		desc = "LSP Workspace Symbols",
		has = "workspace/symbols",
	},
}

---@param method string|string[]
function M.has(buffer, method)
	if type(method) == "table" then
		for _, m in ipairs(method) do
			if M.has(buffer, m) then
				return true
			end
		end
		return false
	end
	method = method:find("/") and method or "textDocument/" .. method
	local clients = vim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

---@param value string|LSPKeymapSpec
---@param mode? string
---@return LSPKeymap
function M.parse(value, mode)
	value = type(value) == "string" and { value } or value --[[@as LSPKeymapSpec]]
	local ret = vim.deepcopy(value) --[[@as LSPKeymap]]
	ret.lhs = ret[1] or ""
	ret.rhs = ret[2]
	---@diagnostic disable-next-line: no-unknown
	ret[1] = nil
	---@diagnostic disable-next-line: no-unknown
	ret[2] = nil
	ret.mode = mode or "n"
	ret.id = vim.api.nvim_replace_termcodes(ret.lhs, true, true, true)

	if ret.mode ~= "n" then
		ret.id = ret.id .. " (" .. ret.mode .. ")"
	end
	return ret
end

---@param spec? (string|LSPKeymapSpec)[]
function M.resolve(spec)
	---@type LSPKeymap[]
	local values = {}
	---@diagnostic disable-next-line: no-unknown
	for _, value in ipairs(spec or {}) do
		value = type(value) == "string" and { value } or value --[[@as LSPKeymapSpec]]
		value.mode = value.mode or "n"
		local modes = (type(value.mode) == "table" and value.mode or { value.mode }) --[=[@as string[]]=]
		for _, mode in ipairs(modes) do
			local keys = M.parse(value, mode)
			if keys.rhs == vim.NIL or keys.rhs == false then
				values[keys.id] = nil
			else
				values[keys.id] = keys
			end
		end
	end
	return values
end

function M.on_attach(_, buffer)
	local keymaps = M.resolve(M._keys)

	for _, key in pairs(keymaps) do
		local has = not key.has or M.has(buffer, key.has)
		local cond = not (key.cond == false or ((type(key.cond) == "function") and not key.cond()))

		if has and cond then
			-- FIXME: parse properly
			vim.keymap.set(key.mode or "n", key.lhs, key.rhs, { desc = key.desc })
		end
	end
end

return M
