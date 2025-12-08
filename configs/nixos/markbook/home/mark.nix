/**
  * home-manager gui config (for nixos)
  * Notes:
  * - Hyprland HiDPI scaling can be set via `wayland.windowManager.hyprland.settings.monitor`
  *   e.g., monitor = "eDP-1,2560x1600@60,0x0,2"; for 2x scale or 1.5 for more space.
*/
{ lib, pkgs, ... }:
{
  feltnerm.home.gui.enable = true;

  # Optional per-user Stylix tweaks (e.g., HiDPI-aware fonts)
  stylix = {
    enable = lib.mkDefault true;
    enableReleaseChecks = lib.mkDefault false;
    fonts.monospace = {
      package = lib.mkDefault pkgs.nerd-fonts.jetbrains-mono;
      name = lib.mkDefault "JetBrainsMono Nerd Font Mono";
    };
  };
}
