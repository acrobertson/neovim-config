require("snacks").setup({
	bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	toggle = { enabled = true },
	-- TODO: enable after LSP is setup
	-- words = { enabled = true },
})
