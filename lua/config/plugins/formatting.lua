return {
	{
		"conform.nvim",

		event = { "BufWritePre", "DeferredUIEnter" },
		cmd = "ConformInfo",

		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},

		after = function()
			---@type conform.setupOpts
			local opts = {
				default_format_opts = {
					timeout_ms = 3000,
					async = false,
					quiet = false,
					lsp_format = "fallback",
				},
				-- NOTE: this omits builtin prettier filetypes, which will be inserted below
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "nixfmt" },
					blade = { "prettier" },
					twig = { "prettier" },
				},
				formatters = {
					injected = { options = { ignore_errors = true } },
					prettier = {
						condition = function(config, ctx)
							return Config.prettier.has_parser(config, ctx)
								and Config.prettier.has_config(config, ctx)
						end,
					},
				},
			}

			for _, ft in ipairs(Config.prettier.builtin_filetypes) do
				opts.formatters_by_ft[ft] = { "prettier" }
			end

			require("conform").setup(opts)

			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

			Config.format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					require("conform").format({ bufnr = buf })
				end,
				sources = function(buf)
					local ret = require("conform").list_formatters(buf)
					---@param v conform.FormatterInfo
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end,
	},
}
