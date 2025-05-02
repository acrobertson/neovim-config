local servers = {
	html = {},
	denols = {},
	phpactor = {},
}

servers.cssls = {
	css = {
		lint = {
			unknownAtRules = "ignore",
		},
	},
}

-- TODO: set up `nvim-emmet`
servers.emmet_language_server = {
	filetypes = {
		"astro",
		"css",
		"eruby",
		"heex",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"php",
		"sass",
		"scss",
		"svelte",
		"pug",
		"twig",
		"typescriptreact",
		"vue",
	},
}

servers.eslint = {
	-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
	workingDirectories = { mode = "auto" },
	format = true,
	-- NOTE: try these if things get slow
	-- flags = {
	-- 	allow_incremental_sync = false,
	-- 	debounce_text_changes = 1000,
	-- },
}

-- TODO: integrate `schemastore`
servers.jsonls = {
	json = {
		format = {
			enable = true,
		},
		validate = { enable = true },
	},
}

servers.lua_ls = {
	Lua = {
		workspace = {
			checkThirdParty = false,
		},
		codeLens = {
			enable = true,
		},
		completion = {
			callSnippet = "Replace",
		},
		doc = {
			privateName = { "^_" },
		},
		hint = {
			enable = true,
			setType = false,
			paramType = true,
			paramName = "Disable",
			semicolon = "Disable",
			arrayIndex = "Disable",
		},
	},
}

servers.nixd = {
	nixd = {
		nixpkgs = {
			-- nixd requires some configuration in flake based configs.
			-- luckily, the nixCats plugin is here to pass whatever we need!
			expr = [[import (builtins.getFlake "]]
				.. nixCats.extra("nixdExtras.nixpkgs")
				.. [[") { }   ]],
		},
		formatting = {
			command = { "nixfmt" },
		},
		diagnostic = {
			suppress = {
				"sema-escaping-with",
			},
		},
		options = {},
	},
}
-- If you integrated with your system flake,
-- you should pass inputs.self as nixdExtras.flake-path
-- that way it will ALWAYS work, regardless
-- of where your config actually was.
-- otherwise flake-path could be an absolute path to your system flake, or nil or false
if nixCats.extra("nixdExtras.flake-path") then
	local flakePath = nixCats.extra("nixdExtras.flake-path")
	if nixCats.extra("nixdExtras.systemCFGname") then
		-- (builtins.getFlake "<path_to_system_flake>").nixosConfigurations."<name>".options
		servers.nixd.nixd.options.nixos = {
			expr = [[(builtins.getFlake "]]
				.. flakePath
				.. [[").nixosConfigurations."]]
				.. nixCats.extra("nixdExtras.systemCFGname")
				.. [[".options]],
		}
	end
	if nixCats.extra("nixdExtras.homeCFGname") then
		-- (builtins.getFlake "<path_to_system_flake>").homeConfigurations."<name>".options
		servers.nixd.nixd.options["home-manager"] = {
			expr = [[(builtins.getFlake "]] .. flakePath .. [[").homeConfigurations."]] .. nixCats.extra(
				"nixdExtras.homeCFGname"
			) .. [[".options]],
		}
	end
end

servers.tailwindcss = {
	filetypes_exclude = { "markdown" },
	includeLanguages = {
		elixir = "html-eex",
		eelixir = "html-eex",
		heex = "html-eex",
	},
}

servers.yamlls = {
	-- TODO: capabilities
	yaml = {
		keyOrdering = false,
		format = {
			enable = true,
		},
		validate = true,
	},
}

return {
	{
		"nvim-lspconfig",

		event = {
			"BufReadPost",
			"BufNewFile",
			"BufWritePre",
		},

		load = vim.cmd.packadd,

		after = function()
			-- Set up auto-format
			Config.format.register(Config.lsp.formatter())
			Config.format.register(Config.lsp.formatter({
				name = "eslint: lsp",
				primary = false,
				priority = 200,
				filter = "eslint",
			}))

			-- Set up keymaps
			Config.lsp.on_attach(function(client, buffer)
				require("config.plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			Config.lsp.setup()
			Config.lsp.on_dynamic_capability(require("config.plugins.lsp.keymaps").on_attach)

			-- Set up diagnostics
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					current_line = true,
				},
			})

			-- Set up inlay hints
			Config.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
				if
					vim.api.nvim_buf_is_valid(buffer)
					and vim.bo[buffer].buftype == ""
					and not vim.tbl_contains({ "vue" }, vim.bo[buffer].filetype)
				then
					vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
				end
			end)

			-- TODO: Set up codelens
			-- Config.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
			-- 	vim.lsp.codelens.refresh()
			-- 	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			-- 		buffer = buffer,
			-- 		callback = vim.lsp.codelens.refresh,
			-- 	})
			-- end)

			require("lz.n").trigger_load("blink.cmp")

			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("blink-cmp").get_lsp_capabilities(),
				{
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				}
			)

			for server_name, cfg in pairs(servers) do
				require("lspconfig")[server_name].setup({
					capabilities = vim.deepcopy(capabilities),
					settings = cfg,
					filetypes = (cfg or {}).filetypes,
					cmd = (cfg or {}).cmd,
					root_pattern = (cfg or {}).root_pattern,
				})
			end

			require("lz.n").trigger_load("typescript-tools.nvim")

			-- Prevent Deno and Typescript LSPs from conflicting
			if Config.lsp.is_enabled("denols") and Config.lsp.is_enabled("typescript-tools") then
				local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
				Config.lsp.disable("typescript-tools", is_deno)
				Config.lsp.disable("denols", function(root_dir, config)
					if not is_deno(root_dir) then
						config.settings.deno.enable = false
					end
					return false
				end)
			end
		end,
	},

	{
		"typescript-tools.nvim",
		lazy = true,
		-- event = "DeferredUIEnter",
		after = function()
			require("typescript-tools").setup({
				expose_as_code_action = "all",
				---@see https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439 for available preferencesaa
				tsserver_file_preferences = {
					-- TODO: get inlay hints working
					includeInlayParameterNameHints = "literals",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayPropertyDeclarationTypeHints = false,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = false,
					includeCompletionsForModuleExports = true,
				},
				complete_function_calls = true,
			})
		end,
	},
}
