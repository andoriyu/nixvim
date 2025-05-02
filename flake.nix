{
  description = "A nixvim configuration";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://andoriyu-nixvim.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "andoriyu-nixvim.cachix.org-1:lbYebqqAT6xXnTeRlvo5eW18VeRNTCZNGLQ/UsPqr+0="
    ];
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixvim,
    nixpkgs,
    flake-parts,
    nix-github-actions,
    home-manager,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      flake = {
        # Home Manager module
        homeManagerModules.default = { config, lib, pkgs, ... }: 
          let 
            # Import the module directly with the nixvim input
            module = import ./home-manager-module.nix { 
              inherit pkgs config lib;
              nixvim = inputs.nixvim;
            };
          in module;
        
        # NixOS module
        nixosModules.default = { config, pkgs, lib, ... }: {
          imports = [ self.homeManagerModules.default ];
        };
        
        # Library functions that can be used by consumers of this flake
        lib = {
          # Function to build a custom nixvim configuration
          mkNixvim = { system, go ? false, docker ? false, terraform ? false, web ? false, rust ? false, none-ls ? false }:
            let
              pkgs = nixpkgs.legacyPackages.${system};
              nixvim' = nixvim.legacyPackages.${system};
            in
              nixvim'.makeNixvimWithModule {
                inherit pkgs;
                module = {
                  imports = [ ./config ];
                  coldsteel.nixvim = {
                    inherit go docker terraform web rust;
                    "none-ls" = none-ls;
                  };
                };
              };
        };
        
        # GitHub Actions
        githubActions = nix-github-actions.lib.mkGithubMatrix {
          checks = nixpkgs.lib.getAttrs ["x86_64-linux" "aarch64-darwin"] self.checks;
        };
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
          
        nixvimModuleFull = {
          inherit pkgs;
          module = import ./full.nix; # import the module directly
          extraSpecialArgs = {};
        };
        
        nvimFull = nixvim'.makeNixvimWithModule nixvimModuleFull;
        
        nixvimModuleLite = {
          inherit pkgs;
          module = import ./lite.nix; # import the module directly
          extraSpecialArgs = {};
        };
        
        nvimLite = nixvim'.makeNixvimWithModule nixvimModuleLite;
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModuleFull;
          nvim-lite = nvimLite;
          nvim-full = nvimFull;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvimLite;
          nvim-lite = nvimLite;
          nvim-full = nvimFull;
          
          docker-full = pkgs.dockerTools.buildImage {
            name = "nvim";
            tag = "full";
            config = {
              Cmd = ["${nvimFull}/bin/nvim"];
            };
          };
          docker-lite = pkgs.dockerTools.buildImage {
            name = "nvim";
            tag = "lite";
            config = {
              Cmd = ["${nvimLite}/bin/nvim"];
            };
          };
        };
        formatter = pkgs.alejandra;
      };
    };
}
