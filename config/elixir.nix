{
  config,
  pkgs,
  ...
}: let
  cfg = config.coldsteel.nixvim;
in {
  config = {
    # Add Elixir-specific packages
    extraPackages = with pkgs; [
      # Elixir Language Server
      elixir-ls
      # Mix formatter (included with Elixir)
    ] ++ (if cfg.elixir then [elixir] else []);

    # Treesitter support for Elixir
    plugins.treesitter.settings.ensure_installed = 
      if cfg.elixir then ["elixir" "heex" "eex"] else [];

    # Additional Elixir-specific keymaps
    keymaps = if cfg.elixir then [
      {
        mode = "n";
        key = "<leader>em";
        action = ":!mix test<CR>";
        options = {
          silent = true;
          desc = "Run mix test";
        };
      }
      {
        mode = "n";
        key = "<leader>ec";
        action = ":!mix compile<CR>";
        options = {
          silent = true;
          desc = "Run mix compile";
        };
      }
      {
        mode = "n";
        key = "<leader>ed";
        action = ":!mix deps.get<CR>";
        options = {
          silent = true;
          desc = "Get mix dependencies";
        };
      }
      {
        mode = "n";
        key = "<leader>ef";
        action = ":!mix format %<CR>";
        options = {
          silent = true;
          desc = "Format current Elixir file";
        };
      }
    ] else [];

    # File type associations
    filetype = if cfg.elixir then {
      extension = {
        ex = "elixir";
        exs = "elixir";
        heex = "heex";
        eex = "eex";
      };
    } else {};

    # Auto-commands for Elixir files
    autoCmd = if cfg.elixir then [
      {
        event = ["BufRead" "BufNewFile"];
        pattern = ["*.ex" "*.exs"];
        command = "set filetype=elixir";
      }
      {
        event = ["BufRead" "BufNewFile"];
        pattern = ["*.heex"];
        command = "set filetype=heex";
      }
      {
        event = ["BufRead" "BufNewFile"];
        pattern = ["*.eex"];
        command = "set filetype=eex";
      }
    ] else [];
  };
}
