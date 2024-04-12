{
  name = "rust";
  description = "Add 'w' and 'test' targets for running cargo";
  justfile = ''
    # Compile and watch the project
    w:
      cargo watch

    # Run and watch 'cargo test'
    test:
      cargo watch -s "cargo test"
  '';
}
