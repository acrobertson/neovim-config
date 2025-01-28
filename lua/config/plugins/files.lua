return {
	{
		"yazi.nvim",
		event = "DeferredUIEnter",

		keys = {
			{
				"<leader>fm",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi (Directory of Current File)",
			},
			{
				"<leader>fM",
				"<cmd>Yazi cwd<cr>",
				desc = "Open yazi (cwd)",
			},
			{
				"<leader>ft",
				"<cmd>Yazi toggle<cr>",
				desc = "Toggle yazi (Resume last session)",
			},
		},

		after = function()
			require('yazi').setup()
		end
	}
}
