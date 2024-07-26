{lib, ...}: {
  options = {
    coldsteel = {
      go = lib.mkEnableOption {
        description = "Enables plugin support for Go Lang";
        default = true;
      };
      docker = lib.mkEnableOption {
        description = "Enables plugin support for Dockerfiles";
        default = true;
      };
      terraform = lib.mkEnableOption {
        description = "Enables plugin support for Terraform";
        default = true;
      };
      web = lib.mkEnableOption {
        description = "Enables plugin support for Web Development (html, css, javascript, etc)";
        default = true;
      };
      rust = lib.mkEnableOption {
        description = "Enables plugin support for Rust";
        default = true;
      };
      none-ls = lib.mkEnableOption {
        description = "Enables none-ls plugin";
        default = true;
      };
    };
  };
}
