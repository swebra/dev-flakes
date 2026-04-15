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
        gnumake
        just
        pre-commit
        yq
        jq
        python313Packages.uv # TODO: use top-level uv?
      ];
      # Note: No python/pip/venvShellHook, letting uv handle that

      # Below all provides build and runtime dependencies for pip-installed packages

      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.glib # For cv2
        pkgs.libGL # For cv2
      ];
    };
  };
}
