return {
	{
		"conform.nvim",

		cmd = "ConformInfo",

		keys = {
			{
				"<leader>cf",
				function(args)
					local range = nil
					if args.count ~= -1 then
						local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
						range = {
							start = { args.line1, 0 },
							["end"] = { args.line2, end_line:len() },
						}
					end
					require("conform").format({
						async = true,
						lsp_format = "fallback",
						range = range,
						timeout_ms = 500,
					})
				end,
				mode = { "n", "v" },
				desc = "Format buffer or range",
			},
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 1000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},

		after = function()
			require("conform").setup({
				default_format_opts = {
					timeout_ms = 500,
					async = false,
					quiet = false,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					clojure = { "joker" },
					lua = { "stylua" },
					nix = { "nixfmt" },
					php = { "pint" },
					blade = { "prettier" },
					twig = { "prettier" },
					css = { "prettier" },
					graphql = { "prettier" },
					html = { "prettier" },
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					less = { "prettier" },
					markdown = { "prettier" },
					["markdown.mdx"] = { "prettier" },
					scss = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					vue = { "prettier" },
					yaml = { "prettier" },
				},
				formatters = {
					injected = { options = { ignore_errors = true } },
				},
			})

			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
