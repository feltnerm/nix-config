{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  name = "feltnerm-flake";
  NIX_CONFIG = "experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    git
  ];
  shellHook = ''
    exec zsh
  '';
}
