/**
  * home-manager gui config (for nixos)
*/
{ lib, ... }:
{
  feltnerm.home.gui.enable = true;

  # Optional per-user Stylix tweaks (no HM stylix import required)
  stylix = {
    enable = lib.mkDefault true;
    enableReleaseChecks = lib.mkDefault false;
    fonts.monospace = {
      package = lib.mkDefault pkgs.nerd-fonts.jetbrains-mono;
      name = lib.mkDefault "JetBrainsMono Nerd Font Mono";
    };
  };
}
