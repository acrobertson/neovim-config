return {
	{
		"blink.cmp",
		event = "InsertEnter",

		after = function()
			-- TODO: configure icons
			require("blink-cmp").setup({
				appearance = {
					nerd_font_variant = "mono",
				},
				keymap = {
					preset = "default",
				},
				completion = {
					accept = {
						-- experimental auto-brackets support
						auto_brackets = {
							enabled = true,
						},
					},
					menu = {
						border = "rounded",
						draw = {
							treesitter = { "lsp" },
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
						window = {
							border = "rounded",
						},
					},
				},
			})
		end,
	},
}
