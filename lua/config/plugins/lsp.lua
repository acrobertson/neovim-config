return {
	{
		"ts-error-translator-nvim",
		lazy = true,
		after = function()
			require("ts-error-translator").setup()
		end,
	},
}
