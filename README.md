[![project chat](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://nixos.zulipchat.com/#narrow/stream/413950-nix)

# just-flake

Use [`just`](https://just.systems/) in your Nix devShells with re-usable and share-able targets.

> [!WARNING] 
> Module options API is subject to change.


## Usage

In your `flake.nix`:

```nix
# In flake-parts' perSystem
{
  just-flake.features = {
    treefmt.enable = true;
    rust.enable = true;
    convco.enable = true;
    hello = {
      enable = true;
      justfile = ''
        hello:
        echo Hello World
      '';
    };
  };
}
```

In your `justfile`:

```just
# See flake.nix (just-flake)
import 'just-flake.just'

# Display the list of recipes
default:
    @just --list
```

Then, add `config.just-flake.outputs.devShell` to the `inputsFrom` of your devShell.

Resulting devShell banner:

```
🍎🍎 Run 'just <recipe>' to get started
Available recipes:
    changelog # Generate CHANGELOG.md using recent commits
    default   # Display the list of recipes
    fmt       # Auto-format the source tree using treefmt
    hello
    test      # Run and watch 'cargo test'
    w         # Compile and watch the project
```
