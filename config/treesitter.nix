{...}: {
  plugins = {
    treesitter = {
      enable = true;
      settings.indent.enable = false;
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
