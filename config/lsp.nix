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

  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap.preset = "super-tab";
      appearance.nerd_font_variant = "mono";
      sources.default = ["lsp" "path" "snippets" "buffer"];
      completion = {
        documentation.auto_show = true;
        ghost_text.enabled = true;
      };
      signature.enabled = true;
    };
  };

  plugins.lspsaga.enable = true;
  plugins.rustaceanvim = {enable = config.coldsteel.nixvim.rust;};
  extraPackages = with pkgs; [fzf];

  keymaps = [
    # LSP Navigation
    {
      mode = "n";
      key = "gd";
      action = "<cmd>lua vim.lsp.buf.definition()<CR>";
      options = {
        silent = true;
        desc = "Go to definition";
      };
    }
    {
      mode = "n";
      key = "gD";
      action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
      options = {
        silent = true;
        desc = "Go to declaration";
      };
    }
    {
      mode = "n";
      key = "gi";
      action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      options = {
        silent = true;
        desc = "Go to implementation";
      };
    }
    {
      mode = "n";
      key = "gr";
      action = "<cmd>Trouble lsp_references toggle<CR>";
      options = {
        silent = true;
        desc = "References (Trouble)";
      };
    }
    # Lspsaga
    {
      mode = "n";
      key = "K";
      action = "<cmd>Lspsaga hover_doc<CR>";
      options = {
        silent = true;
        desc = "Hover documentation";
      };
    }
    {
      mode = "n";
      key = "<leader>la";
      action = "<cmd>Lspsaga code_action<CR>";
      options = {
        silent = true;
        desc = "Code action";
      };
    }
    {
      mode = "n";
      key = "<leader>lr";
      action = "<cmd>Lspsaga rename<CR>";
      options = {
        silent = true;
        desc = "Rename";
      };
    }
    {
      mode = "n";
      key = "<leader>ld";
      action = "<cmd>Lspsaga show_line_diagnostics<CR>";
      options = {
        silent = true;
        desc = "Line diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>ls";
      action = "<cmd>Lspsaga outline<CR>";
      options = {
        silent = true;
        desc = "Symbols outline";
      };
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
      options = {
        silent = true;
        desc = "Previous diagnostic";
      };
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
      options = {
        silent = true;
        desc = "Next diagnostic";
      };
    }
    # Formatting (via conform.nvim with LSP fallback)
    {
      mode = "n";
      key = "<leader>lf";
      action = ":lua require('conform').format({ async = true, lsp_format = 'fallback' })<CR>";
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
  ] ++ (if config.coldsteel.nixvim.elixir then [
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
  ] else []);
}
