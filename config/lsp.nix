{
  pkgs,
  config,
  ...
}: {
  plugins.lsp = let
    cfg = config.coldsteel.nixvim;
  in {
    enable = true;
    servers = {
      bashls.enable = true;
      dockerls.enable = cfg.docker;
      gopls.enable = cfg.go;
      nixd.enable = true;
      tailwindcss.enable = cfg.web;
      terraformls.enable = cfg.terraform;
      yamlls.enable = true;
      eslint.enable = cfg.web;
      denols.enable = cfg.web;
    };
  };

  plugins.lsp-format.enable = true;

  plugins.lspkind = {
    enable = true;
    cmp.enable = true;
  };

  plugins.luasnip = {
    enable = true;
    fromVscode = [{}];
  };
  plugins.cmp_luasnip.enable = true;
  plugins.lspsaga.enable = true;
  extraPackages = with pkgs; [fzf];
  plugins.cmp = {
    enable = true;
    settings = {
      sources = [
        {name = "buffer";}
        {name = "luasnip";}
        {name = "nvim_lsp";}
        {name = "path";}
        {name = "tmux";}
      ];

      snippet.expand = ''
        function(args)
          require('luasnip').lsp_expand(args.body)
        end'';
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_locally_jumpable() then
              require("luasnip").expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<Up>" = "cmp.mapping.select_prev_item()";
        "<Down>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";
      };
    };
  };
  plugins.cmp-buffer = {enable = true;};

  plugins.cmp-nvim-lsp = {enable = true;};
  plugins.cmp-nvim-lua = {enable = true;};

  plugins.cmp-path = {enable = true;};

  plugins.rustaceanvim = {enable = config.coldsteel.nixvim.rust;};

  keymaps = [
    {
      mode = "n";
      key = "<leader>lf";
      action = ":lua vim.lsp.buf.format()<CR>";
      #    lua = true;
      options = {
        silent = true;
        desc = "Format";
      };
    }
  ];
}
