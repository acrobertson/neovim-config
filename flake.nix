{
  description = "Nix flaked neovim config";

  # see :help nixCats.flake.inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };

    "plugins-flexoki-nvim" = {
      url = "github:nuvic/flexoki-nvim";
      flake = false;
    };

    "plugins-ts-error-translator-nvim" = {
      url = "github:dmmulroy/ts-error-translator.nvim";
      flake = false;
    };
  };

  # see :help nixCats.flake.outputs
  outputs =
    {
      # self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = "${./.}";
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
      extra_pkg_config = {
        # allowUnfree = true;
      };

      # see :help nixCats.flake.outputs.overlays
      dependencyOverlays = # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];

      # see :help nixCats.flake.outputs.categories
      # and
      # :help nixCats.flake.outputs.categoryDefinitions.scheme
      categoryDefinitions =
        { pkgs, ... }:
        {
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          lspsAndRuntimeDeps = {
            general = with pkgs; [
              # system
              fd
              ripgrep
              # nix
              nix-doc
              nixd
              nixfmt-rfc-style
              # lua
              lua-language-server
              stylua
              # php
              phpactor
              # rust
              rust-analyzer
              # schemas
              yaml-language-server
              # twig
              twig-language-server
              # web
              emmet-language-server
              tailwindcss-language-server
              typescript
              vscode-langservers-extracted
              vtsls
              # clojure
              clojure-lsp
              joker
            ];
          };

          # plugins that will load at startup without using packadd
          startupPlugins = {
            gitPlugins = with pkgs.neovimPlugins; [ flexoki-nvim ];
            general = with pkgs.vimPlugins; [
              lz-n
              plenary-nvim
              snacks-nvim
              tokyonight-nvim
              vim-sleuth
            ];
          };

          # not loaded automatically at startup.
          optionalPlugins = {
            gitPlugins = with pkgs.neovimPlugins; [ ts-error-translator-nvim ];
            general = with pkgs.vimPlugins; [
              blink-cmp
              conform-nvim
              crates-nvim
              flash-nvim
              gitsigns-nvim
              grug-far-nvim
              lualine-nvim
              mini-ai
              mini-icons
              mini-pairs
              mini-surround
              neogit
              nvim-treesitter.withAllGrammars
              nvim-treesitter-context
              nvim-treesitter-textobjects
              rustaceanvim
              tabby-nvim
              todo-comments-nvim
              # trouble-nvim
              ts-comments-nvim
              typescript-tools-nvim
              vim-tmux-navigator
              which-key-nvim
              yazi-nvim
            ];
            test = with pkgs.vimPlugins; [
              lazydev-nvim
            ];
          };
        };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions = {
        nvim =
          { ... }:
          {
            # see :help nixCats.flake.outputs.settings
            settings = {
              wrapRc = true;
              configDirName = "nvim";
            };
            categories = {
              general = true;
              gitPlugins = true;
              test = false;
            };
            extra = {
              nixdExtras = {
                flake-path = "/Users/alecrobertson/dotfiles.nix";
                homeCFGname = "alecrobertson";
                nixpkgs = nixpkgs;
              };
            };
          };
        # an extra test package with normal lua reload for fast edits
        nvim-test =
          { ... }:
          {
            settings = {
              wrapRc = false;
              configDirName = "nvim";
              unwrappedCfgPath = "/Users/alecrobertson/neovim-config";
            };
            categories = {
              general = true;
              gitPlugins = true;
              test = true;
            };
            extra = {
              nixdExtras = {
                flake-path = "/Users/alecrobertson/dotfiles.nix";
                homeCFGname = "alecrobertson";
                nixpkgs = nixpkgs;
              };
            };
          };
      };
      defaultPackageName = "nvim";
    in

    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = '''';
          };
        };

      }
    )
    // (
      let
        nixosModule = utils.mkNixosModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        homeModule = utils.mkHomeModules {
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {

        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );

}
