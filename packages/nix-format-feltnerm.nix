{ pkgs, ... }:
let
  name = "nix-format-feltnerm";
in
pkgs.writeShellApplication {
  inherit name;
  runtimeInputs = [
    pkgs.alejandra
    pkgs.statix
    pkgs.deadnix
  ];
  text = ''
    ${pkgs.alejandra}/bin/alejandra . && ${pkgs.statix}/bin/statix fix . && ${pkgs.deadnix}/bin/deadnix -e .
  '';
}
