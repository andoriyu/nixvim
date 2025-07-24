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
      gopls = {
        enable = cfg.go;
        settings = {
          gopls = {
            completeUnimported = true;
            usePlaceholders = true;
            analyses = {
              unusedparams = true;
            };
          };
        };
      };
      nixd.enable = true;
      tailwindcss.enable = cfg.web;
      terraformls.enable = cfg.terraform;
      yamlls.enable = true;
      eslint.enable = cfg.web;
      denols = {
        enable = cfg.web;
        settings = {
          deno = {
            suggest = {
              completeFunctionCalls = false;
              imports = {
                hosts = {
                  "https://deno.land" = true;
                };
              };
            };
          };
        };
      };
      elixirls = {
        enable = cfg.elixir;
        settings = {
          elixirLS = {
            dialyzerEnabled = true;
            fetchDeps = false;
            enableTestLenses = true;
            suggestSpecs = true;
          };
        };
      };
    };
    
    onAttach = ''
      -- Configure LSP import behavior
      if client.server_capabilities.codeActionProvider then
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { "source.organizeImports" } }
            local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
                end
              end
            end
          end,
        })
      end
    '';
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
        {
          name = "nvim_lsp";
          priority = 1000;
          option = {
            markdown_oxide = {
              keyword_pattern = "[[\(\k\| \)]]";
            };
          };
        }
        {name = "luasnip"; priority = 750;}
        {name = "buffer"; priority = 500;}
        {name = "path"; priority = 250;}
        {name = "tmux"; priority = 100;}
      ];

      snippet.expand = ''
        function(args)
          require('luasnip').lsp_expand(args.body)
        end'';
        
      completion = {
        completeopt = "menu,menuone,noinsert";
      };
      
      experimental = {
        ghost_text = true;
      };
      
      mapping = {
        "<CR>" = ''
          cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          })
        '';
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
    {
      mode = "n";
      key = "<leader>lo";
      action = ":lua vim.lsp.buf.code_action({context = {only = {'source.organizeImports'}}, apply = true})<CR>";
      options = {
        silent = true;
        desc = "Organize Imports";
      };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = ":lua vim.lsp.buf.code_action({context = {only = {'source.addMissingImports'}}, apply = true})<CR>";
      options = {
        silent = true;
        desc = "Add Missing Imports";
      };
    }
  ];
}
