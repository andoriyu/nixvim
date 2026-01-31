{
  lib,
  pkgs,
  ...
}: let
  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));
in {
  # Import all your configuration modules here
  imports = (scanPaths ./.) ++ [../module.nix];

  # Plugins that do not require configuration go here
  plugins = {
    indent-blankline.enable = true;
    illuminate.enable = true;
    rainbow-delimiters.enable = true;
    web-devicons.enable = true;
  };


}
