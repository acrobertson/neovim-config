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

		beforeAll = function()
			-- mark netrw as loaded so it's not loaded at all.
			-- see https://github.com/mikavilpas/yazi.nvim/issues/802
			vim.g.loaded_netrwPlugin = 1
		end,

		after = function()
			require("yazi").setup({
				open_for_directories = true,
				integrations = {
					bufdelete_implementation = "snacks-if-available",
					grep_in_directory = "snacks.picker",
					grep_in_selected_files = "snacks.picker",

					replace_in_directory = function(directory)
						-- limit the search to the given path
						local filter = directory:make_relative(vim.uv.cwd())

						require("lz.n").trigger_load("grug-far.nvim")
						require("grug-far").open({
							prefills = {
								paths = filter:gsub(" ", "\\ "),
							},
						})
					end,

					replace_in_selected_files = function(selected_files)
						---@type string[]
						local files = {}
						for _, path in ipairs(selected_files) do
							files[#files + 1] = path:make_relative(vim.uv.cwd()):gsub(" ", "\\ ")
						end

						require("lz.n").trigger_load("grug-far.nvim")
						require("grug-far").open({
							prefills = {
								paths = table.concat(files, " "),
							},
						})
					end,
				},
			})
		end,
	},
}
