---@class config.util
---@field format config.util.format
---@field lsp config.util.lsp
---@field ui config.util.ui
local M = {}

setmetatable(M, {
	__index = function(t, k)
		t[k] = require("config.util." .. k)
		return t[k]
	end,
})

-- Check if a given plugin is pending load
function M.is_pending_load(name)
	local plugin = require("lz.n").lookup(name)
	return plugin ~= nil
end

-- Run a callback when the given plugin has loaded
---@param name string
---@param fn fun(name: string)
function M.on_load(name, fn)
	if M.is_pending_load(name) then
		vim.api.nvim_create_autocmd("User", {
			pattern = { "BufReadPost", "BufNewFile", "BufWritePre" },
			callback = function(event)
				if event.data == name then
					fn(name)
					return true
				end
			end,
		})
	else
		fn(name)
	end
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = { "BufReadPost", "BufNewFile", "BufWritePre" },
		callback = function()
			fn()
		end,
	})
end

---@param opts? {level?: number}
function M.pretty_trace(opts)
	opts = opts or {}
	local trace = {}
	local level = opts.level or 2
	while true do
		local info = debug.getinfo(level, "Sln")
		if not info then
			break
		end
		if info.what ~= "C" then
			local source = info.source:sub(2)
			source = vim.fn.fnamemodify(source, ":p:~:.") --[[@as string]]
			local line = "  - " .. source .. ":" .. info.currentline
			if info.name then
				line = line .. " _in_ **" .. info.name .. "**"
			end
			table.insert(trace, line)
		end
		level = level + 1
	end
	return #trace > 0 and ("\n\n# stacktrace:\n" .. table.concat(trace, "\n")) or ""
end

---@generic R
---@param fn fun():R?
---@param opts? string|{msg:string, on_error:fun(msg)}
---@return R
function M.try(fn, opts)
	opts = type(opts) == "string" and { msg = opts } or opts or {}
	local msg = opts.msg
	-- error handler
	local error_handler = function(err)
		msg = (msg and (msg .. "\n\n") or "") .. err .. M.pretty_trace()
		if opts.on_error then
			opts.on_error(msg)
		else
			vim.schedule(function()
				M.error(msg)
			end)
		end
		return err
	end

	---@type boolean, any
	local ok, result = xpcall(fn, error_handler)
	return ok and result or nil
end

---@alias ConfigNotifyOpts {lang?:string, title?:string, level?:number, once?:boolean, stacktrace?:boolean, stacklevel?:number}

---@param msg string|string[]
---@param opts? NotifyOpts
function M.notify(msg, opts)
	if vim.in_fast_event() then
		return vim.schedule(function()
			M.notify(msg, opts)
		end)
	end

	opts = opts or {}
	if type(msg) == "table" then
		msg = table.concat(
			vim.tbl_filter(function(line)
				return line or false
			end, msg),
			"\n"
		)
	end
	if opts.stacktrace then
		msg = msg .. M.pretty_trace({ level = opts.stacklevel or 2 })
	end
	local lang = opts.lang or "markdown"
	local n = opts.once and vim.notify_once or vim.notify
	n(msg, opts.level or vim.log.levels.INFO, {
		on_open = function(win)
			local ok = pcall(function()
				vim.treesitter.language.add("markdown")
			end)
			if not ok then
				pcall(require, "nvim-treesitter")
			end
			vim.wo[win].conceallevel = 3
			vim.wo[win].concealcursor = ""
			vim.wo[win].spell = false
			local buf = vim.api.nvim_win_get_buf(win)
			if not pcall(vim.treesitter.start, buf, lang) then
				vim.bo[buf].filetype = lang
				vim.bo[buf].syntax = lang
			end
		end,
		title = opts.title or "lazy.nvim",
	})
end

---@param msg string|string[]
---@param opts? ConfigNotifyOpts
function M.error(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.ERROR
	M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? ConfigNotifyOpts
function M.info(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.INFO
	M.notify(msg, opts)
end

---@param msg string|string[]
---@param opts? ConfigNotifyOpts
function M.warn(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.WARN
	M.notify(msg, opts)
end

return M
