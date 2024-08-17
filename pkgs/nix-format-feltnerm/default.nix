{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nix-format-feltnerm";
  runtimeInputs = [pkgs.alejandra pkgs.statix pkgs.deadnix];
  text = ''
    ${pkgs.alejandra}/bin/alejandra . && ${pkgs.statix}/bin/statix fix . && ${pkgs.deadnix}/bin/deadnix -e .
  '';
}
