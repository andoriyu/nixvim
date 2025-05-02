{ pkgs
, lib
, nixvimMock          # import ./nixvim-mock.nix { pkgs = pkgs; system = pkgs.system; }
, hmLib               # home-manager.lib passed by flake.nix
}:

let
  baseModule = { ... }: {
    # absolute minimum every HM config needs
    home.username      = "tester";
    home.homeDirectory = "/homeless-shelter";
    home.stateVersion  = "23.11";
  };

  eval = extraConfig:
    (hmLib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        baseModule
        ../home-manager-module.nix          # the module under test
        ({ ... }: extraConfig)              # per-test overrides
      ];
      extraSpecialArgs = {
        nixvim = nixvimMock;   # expose the mock as the normal "nixvim" arg
      };
    }).config;                              # ← what we assert against
in
eval
