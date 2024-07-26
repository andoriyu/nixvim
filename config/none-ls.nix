{config, ...}: {
  config.plugins.none-ls = {
    enable = config.coldsteel.none-ls;
    sources = {
      code_actions = {
        statix.enable = true;
      };
      diagnostics = {
        actionlint.enable = true;
        statix.enable = true;
        deadnix.enable = true;
        dotenv_linter.enable = true;
        gitlint.enable = true;
        ltrs.enable = true;
        yamllint.enable = true;
      };
      formatting = {
        alejandra.enable = true;
        stylua.enable = true;
        shfmt.enable = true;
        just.enable = true;
        terraform_fmt.enable = true;
        yamlfix.enable = true;
      };
    };
  };
}
