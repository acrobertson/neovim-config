return {
	{
		"mini.icons",

		beforeAll = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,

		after = function()
			require("mini.icons").setup({
				file = {
					[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
					["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
					-- [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
					-- ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
					-- ["eslint.config.cjs"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
					-- ["eslint.config.mjs"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
					-- [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
					-- [".nvmrc"] = { glyph = "", hl = "MiniIconsGreen" },
					-- ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
					-- [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
					-- ["prettier.config.js"] = { glyph = "", hl = "MiniIconsPurple" },
					-- ["prettier.config.cjs"] = { glyph = "", hl = "MiniIconsPurple" },
					-- ["prettier.config.mjs"] = { glyph = "", hl = "MiniIconsPurple" },
					-- ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
					-- ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
					-- [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
					-- ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
				},
				filetype = {
					dotenv = { glyph = "", hl = "MiniIconsYellow" },
				},
			})
		end,
	},
}
