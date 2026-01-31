{pkgs, config, ...}: let
  cfg = config.coldsteel.nixvim;
in {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
      formatters_by_ft = {
        nix = ["alejandra"];
        lua = ["stylua"];
        sh = ["shfmt"];
        bash = ["shfmt"];
        yaml = ["yamlfix"];
      } // (if cfg.elixir then {
        elixir = ["mix"];
        heex = ["mix"];
      } else {});
    };
  };

  extraPackages = with pkgs; [
    alejandra
    stylua
    shfmt
    yamlfix
  ];
}
