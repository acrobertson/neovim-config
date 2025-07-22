return {
	{
		"nvim-treesitter",

		event = {
			"BufReadPost",
			"BufNewFile",
			"BufWritePre",
			"DeferredUIEnter",
		},

		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline

		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},

		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("nvim-treesitter-textobjects")
		end,

		after = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },

				indent = { enable = true },

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},

				textobjects = {
					move = {
						enable = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.inner",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]A"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.inner",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},

	{
		"nvim-treesitter-context",

		event = {
			"BufReadPost",
			"BufNewFile",
			"BufWritePre",
			"DeferredUIEnter",
		},

		after = function()
			local tsc = require("treesitter-context")

			tsc.setup({
				mode = "cursor",
				max_lines = 3,
			})

			Snacks.toggle({
				name = "Treesitter Context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
		end,
	},
}
