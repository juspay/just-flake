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

        mkFeatureModule = name: desc: justfile: {
          enable = lib.mkEnableOption desc;
          justfile = mkJustfileOption name justfile;
        };
      in
      {
        just-flake.features = {
          treefmt = mkFeatureModule "treefmt" "Enable treefmt formatting target (fmt)" ''
            # Auto-format the source tree using treefmt
            fmt:
              treefmt
          '';
          rust = mkFeatureModule "rust" "Enable Rust targets (w; test)" ''
            # Compile and watch the project
            w:
              cargo watch

            # Run and watch 'cargo test'
            test:
              cargo watch -s "cargo test"
          '';
          convco = mkFeatureModule "convco" "Enable convco changelog target (changelog)" ''
            # Generate CHANGELOG.md using recent commits
            changelog:
              convco changelog -p ""
          '';
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
          text = ''
            ${if cfg.features.treefmt.enable 
              then "import '${builtins.toString cfg.features.treefmt.justfile}'" 
              else ""}
            ${if cfg.features.rust.enable 
              then "import '${builtins.toString cfg.features.rust.justfile}'" 
              else ""}
            ${if cfg.features.convco.enable 
              then "import '${builtins.toString cfg.features.convco.justfile}'" 
              else ""}
          '';
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
