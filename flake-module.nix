{
  perSystem = { config, pkgs, lib, ... }: {
    options =
      let
        mkJustfileOption = name: text: lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          default = pkgs.writeTextFile {
            name = "${name}.just";
            inherit text;
          };
        };
        mkFeatureSubmodule = { name, description, justfile }: {
          enable = lib.mkEnableOption description;
          justfile = mkJustfileOption name justfile;
          outputs.justfile = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default =
              let cfg = config.just-flake.features.${name};
              in if cfg.enable
              then "import '${builtins.toString cfg.justfile}'"
              else "";
          };
        };
      in
      {
        just-flake.features = {
          treefmt = mkFeatureSubmodule (import ./nix/features/treefmt.nix);
          rust = mkFeatureSubmodule (import ./nix/features/rust.nix);
          convco = mkFeatureSubmodule (import ./nix/features/convco.nix);
        };

        just-flake.outputs.devShell = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
        };
      };
    config =
      let
        cfg = config.just-flake;
        commonJustfile = pkgs.writeTextFile {
          name = "justfile";
          text =
            lib.concatStringsSep "\n"
              (lib.mapAttrsToList (name: feature: feature.outputs.justfile) cfg.features);
        };
      in
      {
        just-flake.outputs.devShell = pkgs.mkShell {
          packages = [ pkgs.just ];
          shellHook = ''
            ln -sf ${builtins.toString commonJustfile} ./common.just

            echo
            echo "🍎🍎 Run 'just <recipe>' to get started"
            just --list
          '';
        };
      };
  };
}
