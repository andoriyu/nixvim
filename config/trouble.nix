{...}: {
  plugins.trouble = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options = {
        silent = true;
        desc = "Diagnostics (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xd";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options = {
        silent = true;
        desc = "Buffer diagnostics (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xq";
      action = "<cmd>Trouble qflist toggle<CR>";
      options = {
        silent = true;
        desc = "Quickfix (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble loclist toggle<CR>";
      options = {
        silent = true;
        desc = "Location list (Trouble)";
      };
    }
  ];
}
