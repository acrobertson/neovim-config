return {
	{
		"lualine.nvim",
		event = "DeferredUIEnter",

		beforeAll = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,

		after = function()
			require("lualine").setup({
				options = {
					theme = "flexoki",
					component_separators = "",
					section_separators = "",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = {
						statusline = { "snacks_dashboard" },
					},
				},
				sections = {
					lualine_c = {
						{
							"filename",
							path = 4, -- Filename and parent dir, with tilde as the home directory
						},
					},
					lualine_x = {
						"filetype",
					},
				},
			})

			vim.o.laststatus = vim.g.lualine_laststatus
		end,
	},
}
