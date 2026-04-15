{
  description = ''
    A WIP development flake for the pipeline repo
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        uv # letting uv handle python/pip
        pre-commit
        gnumake
        just
        yq
        jq
      ];

      shellHook = ''
        unset PYTHONPATH
        uv sync
        source .venv/bin/activate
      '';

      # Below all provides build and runtime dependencies for pip-installed packages

      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.glib # For cv2
        pkgs.libGL # For cv2
      ];
    };
  };
}
