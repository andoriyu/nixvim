{config, ...}: let
  cfg = config.coldsteel.nixvim;
in {
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        indent.enable = false;
        highlight.enable = true;
        ensure_installed = [
          "bash"
          "c"
          "lua"
          "vim"
          "vimdoc"
          "query"
          "nix"
          "yaml"
          "json"
          "markdown"
          "markdown_inline"
        ] ++ (if cfg.elixir then ["elixir" "heex" "eex"] else [])
          ++ (if cfg.go then ["go" "gomod" "gowork" "gotmpl"] else [])
          ++ (if cfg.rust then ["rust" "toml"] else [])
          ++ (if cfg.web then ["html" "css" "javascript" "typescript" "tsx" "jsx"] else [])
          ++ (if cfg.terraform then ["terraform" "hcl"] else [])
          ++ (if cfg.docker then ["dockerfile"] else []);
      };
      nixvimInjections = true;
    };
    treesitter-textobjects = {
      enable = true;
    };
    treesitter-context = {
      enable = true;
    };
    treesitter-refactor = {
      enable = true;
      highlightDefinitions.enable = true;
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>tc";
      action = "<cmd>TSContextToggle<CR>";
      options.desc = "Toggle treesitter context";
    }
  ];
}
