{...}: {
  plugins.telescope = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      action = "<cmd>Telescope live_grep<CR>";
      key = "<leader>fw";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader>ff";
      options.desc = "Find files";
    }
    {
      mode = "n";
      action = "<cmd>Telescope git_commits<CR>";
      key = "<leader>fg";
      options.desc = "Git commits";
    }
    {
      mode = "n";
      action = "<cmd>Telescope oldfiles<CR>";
      key = "<leader>fh";
      options.desc = "Recent files";
    }
    {
      mode = "n";
      action = "<cmd>Telescope colorscheme<CR>";
      key = "<leader>ch";
      options.desc = "Colorscheme";
    }
    {
      mode = "n";
      action = "<cmd>Telescope man_pages<CR>";
      key = "<leader>fm";
      options.desc = "Man pages";
    }
  ];
}
