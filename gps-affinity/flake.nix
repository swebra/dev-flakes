{
  description = ''
    A development flake for gps-affinity where Python packages can be installed through pip from a
    traditional requirements.txt rather than being managed through nix.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      venvDir = ".venv";
      packages = with pkgs.python312Packages; [
        python
        pip
        venvShellHook
      ];

      # Below all provides build and runtime dependencies for pip-installed packages

      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc];
    };
  };
}
