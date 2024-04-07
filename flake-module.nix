{
  perSystem = { pkgs, ... }: {
    devShells.just = pkgs.mkShell {
      packages = [ pkgs.just ];
      shellHook = ''
        echo
        echo "🍎🍎 Run 'just <recipe>' to get started"
        just
      '';
    };
  };
}
