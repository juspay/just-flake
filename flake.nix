{
  description = "A `flake-parts` module for including `just` in devShell";
  outputs = _: {
    flakeModule = import ./flake-module.nix;

    # https://github.com/srid/nixci
    nixci.default = let overrideInputs = { just-flake = ./.; }; in {
      dev = {
        inherit overrideInputs;
        dir = "dev";
      };

      test = {
        inherit overrideInputs;
        dir = "test";
      };
    };
  };
}
