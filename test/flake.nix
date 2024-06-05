{
  # Since there is no flake.lock file (to avoid incongruent just-flake
  # pinning), we must specify revisions for *all* inputs to ensure
  # reproducibility.
  inputs = {
    nixpkgs = { };
    flake-parts = { };
    just-flake = { };
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.just-flake.flakeModule
      ];

      perSystem = { config, self', pkgs, lib, ... }: {
        just-flake = {
          commonFileName = "justfile";

          features = {
            convco.enable = true;
          };
        };

        devShells.test = pkgs.mkShell {
          inputsFrom = [
            config.just-flake.outputs.devShell
          ];
        };

        # Our test
        checks.test =
          pkgs.runCommandNoCC "test"
            {
              nativeBuildInputs = with pkgs; [
                which
              ] ++ self'.devShells.test.nativeBuildInputs;
            }
            ''
              (
              set -x
              echo "Testing ..."

              which just || \
                (echo "just should be in devshell"; exit 2)

              ${self'.devShells.test.shellHook}

              grep -q treefmt justfile && \
                (echo "justfile should not import treefmt"; exit 2)

              grep -q convco justfile || \
                (echo "justfile should import convco"; exit 2)

              touch $out
              )
            '';
      };
    };
}
