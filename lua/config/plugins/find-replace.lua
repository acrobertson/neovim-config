return {
	-- search/replace in multiple files
	{
		"grug-far.nvim",
		cmd = { "GrugFar", "GrugFarWithin" },
		keys = {
			{
				"<leader>sr",
				function()
					local test = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					test.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
		after = function()
			require("grug-far").setup({
				headerMaxWidth = 80,
			})
		end,
	},
}
