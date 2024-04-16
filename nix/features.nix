# This largely inspired by the use of freeformType in 
# https://github.com/cachix/git-hooks.nix/blob/master/modules/hooks.nix
{ pkgs, lib, ... }:

let
  inherit (lib) types;
  featureMod = {
    imports = [ ./feature.nix ];
    config._module.args = { inherit pkgs; };
  };
  featureType = types.submodule featureMod;
in
{
  imports = [{
    options.features = lib.mkOption {
      type = types.submoduleWith {
        modules = [{ freeformType = types.attrsOf featureType; }];
        specialArgs = { inherit pkgs; };
      };
      default = { };
    };
  }];

  # NOTE: At somepoint, we may want to add `settings` options to some of these features.
  options.features = {
    convco = lib.mkOption {
      description = "Add the 'changelog' target calling convco";
      type = types.submodule { imports = [ featureMod ]; };
    };
    rust = lib.mkOption {
      description = "Add 'w' and 'test' targets for running cargo";
      type = types.submodule { imports = [ featureMod ]; };
    };
    treefmt = lib.mkOption {
      description = "Add the 'fmt' target to format source tree using treefmt";
      type = types.submodule { imports = [ featureMod ]; };
    };
  };

  config.features = lib.mapAttrs (_: lib.mapAttrs (_: lib.mkDefault)) {
    convco.justfile = ''
      # Generate CHANGELOG.md using recent commits
      changelog:
        convco changelog -p ""
    '';
    rust.justfile = ''
      # Compile and watch the project
      w:
        cargo watch

      # Run and watch 'cargo test'
      test:
        cargo watch -s "cargo test"
    '';
    treefmt.justfile = ''
      # Auto-format the source tree using treefmt
      fmt:
        treefmt
    '';
  };
}
