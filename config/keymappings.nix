{...}: {
  keymaps = [
    {
      mode = "n";
      action = "<C-W>v<C-W>l";
      key = "<Leader>v";
      options.desc = "Vertical split";
    }
    {
      mode = "n";
      action = "<C-W>s<C-W>j";
      key = "<Leader>h";
      options.desc = "Horizontal split";
    }
  ];
}
