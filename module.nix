{lib, ...}: {
  options = {
    coldsteel.nixvim = {
      go = lib.mkEnableOption {
        description = "Enables plugin support for Go Lang";
      };
      docker = lib.mkEnableOption {
        description = "Enables plugin support for Dockerfiles";
      };
      terraform = lib.mkEnableOption {
        description = "Enables plugin support for Terraform";
      };
      web = lib.mkEnableOption {
        description = "Enables plugin support for Web Development (html, css, javascript, etc)";
      };
      rust = lib.mkEnableOption {
        description = "Enables plugin support for Rust";
      };
      none-ls = lib.mkEnableOption {
        description = "Enables none-ls plugin";
      };
      elixir = lib.mkEnableOption {
        description = "Enables plugin support for Elixir";
      };
    };
  };
}
