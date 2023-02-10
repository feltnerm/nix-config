{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  packages = [
    pkgs.git

    pkgs.alejandra # nix linter
    pkgs.deadnix # remove unused code
    pkgs.home-manager # home-manager
    pkgs.niv # nix dependency mgmt
    pkgs.nix-diff # compare derivations
    pkgs.nix-index # search for nix packages
    pkgs.statix # nix static analysis
  ];
}
