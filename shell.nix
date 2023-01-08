{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  packages = [
    pkgs.nix
    pkgs.nix-index
    pkgs.nix-diff
    pkgs.home-manager
    pkgs.git

    pkgs.alejandra
    pkgs.statix
  ];
}
