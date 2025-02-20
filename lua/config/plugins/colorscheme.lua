return {
	{
		"flexoki-nvim",
		after = function()
			---@diagnostic disable-next-line: missing-fields
			require("flexoki").setup({
				variant = "auto",
				extend_background_behind_borders = true,
				styles = {
					bold = true,
					italic = false,
					transparency = true,
				},
				groups = {
					border = "highlight_low",
					panel = "overlay",
				},
				highlight_groups = {
					-- Literals
					Boolean = { fg = "purple_two" },
					-- Markup
					htmlArg = { fg = "green_two" },
					htmlTagName = { fg = "blue_two" },
					Tag = { fg = "blue_two" },
					["@tag.attribute"] = { fg = "green_two" },
					["@tag.tsx"] = { fg = "orange_two" },
					-- Types
					-- Type = { fg = "magenta_two" },
					-- ["@type"] = { fg = "magenta_two" },
					-- ["@type.builtin"] = { fg = "magenta_two" },
					-- ["@interface"] = { fg = "magenta_two" },
					-- Parameters
					["@parameter"] = { fg = "blue_two" },
					["@variable.parameter"] = { fg = "blue_two" },
					-- Properties,
					["@property"] = { fg = "text" },
					-- Generic Treesitter identifiers
					["@class"] = { fg = "blue_two" },
					["@constant"] = { fg = "yellow_two" },
					-- ["@variable.builtin"] = { fg = "green_two" },
					["@variable.builtin"] = { fg = "magenta_two" },
					-- Snacks dashboard
					SnacksDashboardHeader = { fg = "blue_two" },
					SnacksDashboardIcon = { fg = "cyan_two" },
					SnacksDashboardDesc = { fg = "cyan_two" },
					SnacksDashboardKey = { fg = "orange_two" },
					-- Whichkey
					WhichKey = { fg = "blue_two" },
					WhichKeyDesc = { fg = "cyan_two" },
					WhichKeyGroup = { fg = "orange_two" },
				},
			})

			vim.cmd.colorscheme("flexoki")
		end,
	},

	{
		"tokyonight.nvim",
		colorscheme = {
			"tokyonight",
			"tokyonight-day",
			"tokyonight-moon",
			"tokyonight-night",
			"tokynight-storm",
		},
	},
}
