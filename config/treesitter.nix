{config, ...}: let
  cfg = config.coldsteel.nixvim;
in {
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        indent.enable = false;
        highlight.enable = true;
      };
      nixvimInjections = true;
      
      # Use grammarPackages instead of ensure_installed for nixvim
      grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        bash
        c
        lua
        vim
        vimdoc
        query
        nix
        yaml
        json
        markdown
        markdown_inline
      ] ++ (if cfg.elixir then [elixir heex] else [])
        ++ (if cfg.go then [go gomod gowork gotmpl] else [])
        ++ (if cfg.rust then [rust toml] else [])
        ++ (if cfg.web then [html css javascript typescript tsx] else [])  # Removed jsx
        ++ (if cfg.terraform then [terraform hcl] else [])
        ++ (if cfg.docker then [dockerfile] else []);
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
