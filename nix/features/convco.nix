{
  name = "convco";
  description = "Add the 'changelog' target calling convco";
  justfile = ''
    # Generate CHANGELOG.md using recent commits
    changelog:
      convco changelog -p ""
  '';
}
