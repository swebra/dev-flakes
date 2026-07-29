{
  description = ''
    A development flake for playing with gotenberg
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        just
        pre-commit

        python311 # Needed to run unoconv/unoconverter
        unoconv # Include original unoconv for reference
      ];

      env.UNO_PATH = "${pkgs.libreoffice-unwrapped}/lib/libreoffice/program/";
    };
  };
}
