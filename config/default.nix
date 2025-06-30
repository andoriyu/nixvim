{
  lib,
  pkgs,
  ...
}: let
  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));
in {
  # Import all your configuration modules here
  imports = (scanPaths ./.) ++ [../module.nix];

  extraConfigLuaPre = ''
    local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    
    -- Configure LSP to handle imports properly
    vim.lsp.handlers["textDocument/completion"] = function(err, result, ctx, config)
      if err then
        return
      end
      
      -- Handle additional text edits (imports) properly
      if result and result.items then
        for _, item in ipairs(result.items) do
          if item.additionalTextEdits then
            -- Ensure imports are added at the correct location
            for _, edit in ipairs(item.additionalTextEdits) do
              if edit.range and edit.range.start then
                -- Validate the edit range
                local start_line = edit.range.start.line
                local end_line = edit.range["end"].line
                if start_line >= 0 and end_line >= start_line then
                  -- Edit is valid
                else
                  -- Clear invalid edits
                  item.additionalTextEdits = {}
                  break
                end
              end
            end
          end
        end
      end
      
      return vim.lsp.handlers["textDocument/completion"](err, result, ctx, config)
    end
  '';

  # Plugins that do not require configuration go here
  plugins = {
    indent-blankline.enable = true;
    illuminate.enable = true;
    rainbow-delimiters.enable = true;
    web-devicons.enable = true;
  };


}
