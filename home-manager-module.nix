{
  lib,
  pkgs,
  config,
  nixvim,
  ...
}: 
with lib;
let
  cfg = config.coldsteel.nixvim;
  
  # Function to build nixvim with the specified options
  buildNixvim = { go ? false, docker ? false, terraform ? false, web ? false, rust ? false, none-ls ? false }:
    nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./config ];
        coldsteel.nixvim = {
          inherit go docker terraform web rust;
          "none-ls" = none-ls;
        };
      };
    };
in {
  options.coldsteel.nixvim = {
    enable = mkEnableOption "Enable coldsteel nixvim configuration";
    
    defaultEditor = mkOption {
      type = types.bool;
      description = "Whether to set nixvim as the default editor";
      default = false;
    };
    
    # Re-export the options from module.nix
    go = mkEnableOption "plugin support for Go Lang";
    docker = mkEnableOption "plugin support for Dockerfiles";
    terraform = mkEnableOption "plugin support for Terraform";
    web = mkEnableOption "plugin support for Web Development";
    rust = mkEnableOption "plugin support for Rust";
    none-ls = mkEnableOption "none-ls plugin";
    
    # Preset configurations
    preset = mkOption {
      type = types.enum [ "none" "lite" "full" "custom" ];
      default = "custom";
      description = ''
        Preset configuration to use:
        - none: No language support
        - lite: Minimal configuration without language-specific plugins
        - full: Full configuration with all language support
        - custom: Use the individual options (go, docker, etc.)
      '';
    };
  };

  config = mkIf cfg.enable {
    # Build a custom nixvim package based on the preset or custom options
    home.packages = let
      nvimPackage = 
        if cfg.preset == "lite" then
          nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
            inherit pkgs;
            module = import ./lite.nix;
          }
        else if cfg.preset == "full" then
          nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
            inherit pkgs;
            module = import ./full.nix;
          }
        else if cfg.preset == "none" then
          buildNixvim {
            go = false;
            docker = false;
            terraform = false;
            web = false;
            rust = false;
            none-ls = false;
          }
        else
          # Custom configuration
          buildNixvim {
            inherit (cfg) go docker terraform web rust;
            none-ls = cfg.none-ls;
          };
    in [ nvimPackage ];
    
    # Set as default editor if requested
    programs.bash.shellAliases = mkIf cfg.defaultEditor {
      vi = "nvim";
      vim = "nvim";
    };
    
    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
