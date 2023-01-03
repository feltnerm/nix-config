{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  packages = [
    pkgs.nix
    pkgs.home-manager
    pkgs.git

    pkgs.alejandra
    pkgs.statix
  ];
}
