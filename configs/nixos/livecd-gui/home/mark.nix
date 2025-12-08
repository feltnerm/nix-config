/**
  * home-manager GUI config for livecd-gui
*/
{ lib, pkgs, ... }:
{
  feltnerm.home.gui.enable = true;

  # Optional per-user Stylix tweaks (for livecd, keep minimal)
  stylix = {
    enable = lib.mkDefault true;
    enableReleaseChecks = lib.mkDefault false;
    fonts.monospace = {
      package = lib.mkDefault pkgs.nerd-fonts.jetbrains-mono;
      name = lib.mkDefault "JetBrainsMono Nerd Font Mono";
    };
  };
}
