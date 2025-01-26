return {
	-- Highlight and search todo comments
	{
		"todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = {
			"BufReadPost",
			"BufNewFile",
			"BufWritePre",
		},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},
			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
			{
				"<leader>xT",
				"<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
				desc = "Todo/Fix/Fixme (Trouble)",
			},
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
			{ "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
		},
		after = function()
			require("todo-comments").setup()
		end,
	},

	-- Language-specific comment strings
	{
		"ts-comments.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("ts-comments").setup()
		end,
	},
}
