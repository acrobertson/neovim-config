local surround_mappings = {
	add = "gsa", -- Add surrounding in Normal and Visual modes
	delete = "gsd", -- Delete surrounding
	find = "gsf", -- Find surrounding (to the right)
	find_left = "gsF", -- Find surrounding (to the left)
	highlight = "gsh", -- Highlight surrounding
	replace = "gsr", -- Replace surrounding
	update_n_lines = "gsn", -- Update `n_lines`
}

return {
	{
		"mini.surround",
		keys = {
			{ surround_mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
			{ surround_mappings.delete, desc = "Delete Surrounding" },
			{ surround_mappings.find, desc = "Find Right Surrounding" },
			{ surround_mappings.find_left, desc = "Find Left Surrounding" },
			{ surround_mappings.highlight, desc = "Highlight Surrounding" },
			{ surround_mappings.replace, desc = "Replace Surrounding" },
			{ surround_mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
		},
		after = function()
			require("mini.surround").setup({
				mappings = surround_mappings,
			})
		end,
	},
}
