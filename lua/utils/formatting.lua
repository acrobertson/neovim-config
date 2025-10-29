local M = {}

---@param buf? number
function M.autoformat_enabled(buf)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local gaf = vim.g.autoformat
	local baf = vim.b[buf].autoformat

	-- If the buffer has a local value, use that
	if baf ~= nil then
		return baf
	end

	-- Otherwise use the global value if set, or true by default
	return gaf == nil or gaf
end

---@param enable? boolean
---@param buf? boolean
function M.enable_autoformat(enable, buf)
	if enable == nil then
		enable = true
	end
	if buf then
		vim.b.autoformat = enable
	else
		vim.g.autoformat = enable
		vim.b.autoformat = nil
	end
end

---@param buf? boolean
function M.snacks_toggle(buf)
	return require("snacks").toggle({
		name = "Auto Format/Save (" .. (buf and "Buffer" or "Global") .. ")",
		get = function()
			if not buf then
				return vim.g.autoformat == nil or vim.g.autoformat
			end
			return M.autoformat_enabled()
		end,
		set = function(state)
			M.enable_autoformat(state, buf)
		end,
	})
end

return M
