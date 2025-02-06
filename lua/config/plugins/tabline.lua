return {
	{
		"tabby.nvim",
		event = "VimEnter",
		after = function()
			require("tabby").setup({
				preset = "tab_only",
				option = {
					lualine_theme = "tokyonight",
				},
			})
		end,
	},
}
