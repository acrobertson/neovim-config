local M = {}

---@param opts? {bufnr?: number, async?: boolean}
function M.eslint_fix_all(opts)
	opts = opts or {}

	local eslint_lsp_client = vim.lsp.get_clients({ bufnr = opts.bufnr, name = "eslint" })[1]
	if eslint_lsp_client == nil then
		return
	end

	local request
	if opts.async then
		request = function(bufnr, method, params)
			eslint_lsp_client:request(method, params, nil, bufnr)
		end
	else
		request = function(bufnr, method, params)
			eslint_lsp_client:request_sync(method, params, 500, bufnr)
		end
	end

	local bufnr = opts.bufnr or 0
	vim.validate("bufnr", bufnr, "number")
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

	request(bufnr, "workspace/executeCommand", {
		command = "eslint.applyAllFixes",
		arguments = {
			{
				uri = vim.uri_from_bufnr(bufnr),
				version = vim.lsp.util.buf_versions[bufnr],
			},
		},
	})
end

return M
