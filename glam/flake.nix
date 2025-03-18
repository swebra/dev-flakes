{
  description = ''
    A development flake for glam where Python packages can be installed through pip from a
    traditional requirements.txt rather than being managed through nix.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # mkShellNoCC not applicable as h3 requires C compiling
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs.python313Packages; [
        python
        pip
        venvShellHook
      ];

      venvDir = ".venv";
      postVenvCreation = "pip install -r requirements.txt";

      # Below all provides build and runtime dependencies for pip-installed packages

      env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib];
    };
  };
}
