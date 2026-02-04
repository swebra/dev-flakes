{
  description = ''
    A flake for running the jsdrive test harness.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages =
        [pkgs.nodejs_20]
        ++ (with pkgs.python3Packages; [
          python
          requests
        ]);
    };
  };
}
