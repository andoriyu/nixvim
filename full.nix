{
  imports = [./config];

  coldsteel.nixvim = {
    go = true;
    docker = true;
    terraform = true;
    web = true;
    rust = true;
    elixir = true;
    none-ls = true;
  };
}
