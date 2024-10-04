{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    git

    nixfmt-rfc-style # nix linter
    deadnix # remove unused code
    home-manager # home-manager
    niv # nix dependency mgmt
    nix-diff # compare derivations
    nix-index # search for nix packages
    statix # nix static analysis
  ];
}
