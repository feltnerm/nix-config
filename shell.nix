{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.nix
    pkgs.home-manager
    pkgs.git

    pkgs.alejandra
    pkgs.statix
  ];
}
