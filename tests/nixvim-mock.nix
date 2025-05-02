{ pkgs, system }:

let
  makeNvim = { module, ... }:
    # A dummy derivation that pretends to be an nvim package
    pkgs.runCommand "mock-nixvim-${system}" {} ''
      mkdir -p $out/bin
      cat > $out/bin/nvim <<'EOF'
      #!${pkgs.runtimeShell}
      echo "Mock Nixvim – enabled features: ${builtins.toJSON module.coldsteel.nixvim or {}}"
      EOF
      chmod +x $out/bin/nvim
    '';
in
{
  legacyPackages.${system}.makeNixvimWithModule = makeNvim;
}
