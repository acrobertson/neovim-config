return {
	{ "vim-sleuth" },
	{
		"lazydev.nvim",
		enabled = function()
			return nixCats("test")
		end,
		ft = "lua",
		cmd = { "LazyDev" },
		after = function()
			---@diagnostic disable-next-line: missing-fields
			require("lazydev").setup({
				library = {
					{
						path = (require("nixCats").nixCatsPath or "") .. "/lua",
						words = { "nixCats" },
					},
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					{ path = "snacks.nvim", words = { "Snacks" } },
				},
			})
		end,
	},
	require("config.plugins.colorscheme"),
	require("config.plugins.snacks"),
	require("config.plugins.treesitter"),
	require("config.plugins.which-key"),
	require("config.plugins.lsp"),
}
