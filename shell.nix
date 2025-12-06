{
  pkgs ? import <nixpkgs> { },
}:
let
  flake = builtins.getFlake (toString ./.);
in
flake.devShells.${pkgs.system}.default
