{
  description = "A `flake-parts` module for including `just` in devShell";
  outputs = _: {
    flakeModule = import ./flake-module.nix;
  };
}
