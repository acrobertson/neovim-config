---@brief
---
--- https://github.com/nix-community/nixd
---
--- Nix language server, based on nix libraries.

local options = {}

if nixCats.extra("nixdExtras.flake-path") then
	local flakePath = nixCats.extra("nixdExtras.flake-path")
	if nixCats.extra("nixdExtras.systemCFGname") then
		-- (builtins.getFlake "<path_to_system_flake>").nixosConfigurations."<name>".options
		options.nixos = {
			expr = [[(builtins.getFlake "]]
				.. flakePath
				.. [[").nixosConfigurations."]]
				.. nixCats.extra("nixdExtras.systemCFGname")
				.. [[".options]],
		}
	end
	if nixCats.extra("nixdExtras.homeCFGname") then
		-- (builtins.getFlake "<path_to_system_flake>").homeConfigurations."<name>".options
		options["home-manager"] = {
			expr = [[(builtins.getFlake "]] .. flakePath .. [[").homeConfigurations."]] .. nixCats.extra(
				"nixdExtras.homeCFGname"
			) .. [[".options]],
		}
	end
end

return {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	settings = {
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
			options = options,
		},
	},
}
