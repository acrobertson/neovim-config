local servers = {}

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
			-- TODO: set up autoformat

			-- Set up keymaps
			Config.lsp.on_attach(function(client, buffer)
				require("config.plugins.lsp.keymaps").on_attach(client, buffer)
			end)

			Config.lsp.setup()
			Config.lsp.on_dynamic_capability(require("config.plugins.lsp.keymaps").on_attach)

			-- TODO: inlay hints

			-- TODO: codelens

			-- TODO: completion

			--- setup
			-- TODO: compare with lazyvim approach
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities =
			-- 	vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			-- capabilities.textDocument.completion.completionItem.snippetSupport = true

			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				-- TODO: enable when blink is configured
				-- blink.get_lsp_capabilities(),
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
		end,
	},
}
