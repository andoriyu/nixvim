{...}: {
  plugins.flash = {
    enable = true;
  };
  keymaps = [
    {
      mode = ["n" "x" "o"];
      key = "s";
      action = ":lua require('flash').jump()<CR>";
      options = {
        silent = true;
        desc = "Flash";
      };
    }
    {
      mode = ["n" "x" "o"];
      key = "S";
      action = ":lua require('flash').treesitter()<CR>";
      options = {
        silent = true;
        desc = "Flash Treesitter";
      };
    }
  ];
}
