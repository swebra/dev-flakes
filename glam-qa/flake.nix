{
  description = ''
    A development flake for glam's QA automation where Python packages can be installed through pip
    from a traditional requirements.txt rather than being managed through nix.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
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
