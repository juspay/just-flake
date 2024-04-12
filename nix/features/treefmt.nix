{
  name = "treefmt";
  description = "Add the 'fmt' target to format source tree using treefmt";
  justfile = ''
    # Auto-format the source tree using treefmt
    fmt:
      treefmt
  '';
}
