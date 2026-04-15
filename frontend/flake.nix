{
  description = ''
    A WIP development flake for the frontend repo
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
        nodejs_20 # TODO: Match docker version
        pre-commit
      ];
    };
  };
}
