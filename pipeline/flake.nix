{
  description = ''
    A WIP development flake for the pipeline repo
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages =
        [
          # TODO: 26.11: consider going back to stable uv
          pkgsUnstable.uv # letting uv handle python/pip
        ]
        ++ (with pkgs; [
          pre-commit
          gnumake
          just
          yq
          jq
        ]);

      shellHook = ''
        unset PYTHONPATH
        uv sync --extra test
        source .venv/bin/activate
      '';

      # Below all provides build and runtime dependencies for pip-installed packages

      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.glib # For cv2
        pkgs.libGL # For cv2
        pkgs.libxcb # For cv2
        pkgs.libz # For numpy
      ];
    };
  };
}
