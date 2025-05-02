{ pkgs, lib, nixvimMock, hmLib }:

let
  eval = import ./eval-home-module.nix { inherit pkgs lib nixvimMock hmLib; };

  cases = [
    {
      name   = "basic-enable";
      config = { coldsteel.nixvim.enable = true; };
      check  = cfg: 
        let
          isMock = p: lib.hasInfix "mock-nixvim" (toString p);
          cnt    = builtins.length (builtins.filter isMock cfg.home.packages);
        in lib.assertMsg
             (cnt == 1)
             "expected exactly one mock-nixvim package, found ${toString cnt}";
    }
    {
      name   = "with-go-rust";
      config = {
        coldsteel.nixvim = { enable = true; go = true; rust = true; };
      };
      check  = cfg:
        let
          isMock = p: lib.hasInfix "mock-nixvim" (toString p);
          cnt    = builtins.length (builtins.filter isMock cfg.home.packages);
        in lib.assertMsg
             (cnt == 1)
             "expected exactly one mock-nixvim package, found ${toString cnt}";
    }
    {
      name   = "default-editor";
      config = { coldsteel.nixvim = { enable = true; defaultEditor = true; }; };
      check  = cfg:
        cfg.home.sessionVariables.EDITOR == "nvim"
        && cfg.programs.bash.shellAliases.vim == "nvim";
    }
    {
      name   = "preset-full";
      config = { coldsteel.nixvim = { enable = true; preset = "full"; }; };
      check  = cfg:
        let
          isMock = p: lib.hasInfix "mock-nixvim" (toString p);
          cnt    = builtins.length (builtins.filter isMock cfg.home.packages);
        in lib.assertMsg
             (cnt == 1)
             "expected exactly one mock-nixvim package, found ${toString cnt}";
    }
  ];

  results = builtins.map (c:
    let cfg = eval c.config;
    in { name = c.name; passed = c.check cfg; })
    cases;

  allPassed = builtins.all (r: r.passed) results;

  report = builtins.concatStringsSep "\n"
    (map (r: "Test ${r.name}: ${if r.passed then "PASSED" else "FAILED"}")
     results);
in
pkgs.runCommand "hm-module-tests"
  { passthru.tests = results; inherit allPassed; }
  ''
    echo "${report}" > $out
    ${lib.optionalString (!allPassed) "exit 1"}
  ''
