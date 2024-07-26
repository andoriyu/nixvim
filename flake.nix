{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModuleFull = {
          inherit pkgs;
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
          };
        };
        nvimFull = nixvim'.makeNixvimWithModule nixvimModuleFull;
        nixvimModuleLite = {
          inherit pkgs;
          module = import ./lite.nix; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
          };
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
