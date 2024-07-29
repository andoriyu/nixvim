{pkgs, ...}: {
  extraPlugins = [
    {
      plugin = pkgs.vimPlugins.catppuccin-nvim;
      config = ''
        lua << EOF
          local compile_path = vim.fn.stdpath("cache") .. "/catppuccin-nvim"
          vim.fn.mkdir(compile_path, "p")
          vim.opt.runtimepath:append(compile_path)

          require("catppuccin").setup({
              compile_path = compile_path,
              flavour = "mocha",
              })
          vim.api.nvim_command("colorscheme catppuccin")
        EOF
      '';
    }
  ];
}
