{ config, name, justfile, pkgs, lib, ... }:

let
  mkJustfileOption = text: lib.mkOption {
    type = lib.types.path;
    readOnly = true;
    description = ''
      The justfile representing this feature.
    '';
    default = pkgs.writeTextFile {
      name = "${name}.just";
      inherit text;
    };
  };
in
{
  options = {
    enable = lib.mkEnableOption "Enable this feature";
    justfile = mkJustfileOption justfile;
    outputs.justfile = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = ''
        The justfile code for importing this feature's justfile.

        See https://just.systems/man/en/chapter_53.html
      '';
      default =
        if config.enable
        then "import '${builtins.toString config.justfile}'"
        else "";
    };
  };
}
