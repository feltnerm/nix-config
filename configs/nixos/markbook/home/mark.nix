/**
  * home-manager gui config (for nixos)
  * Notes:
  * - Hyprland HiDPI scaling can be set via `wayland.windowManager.hyprland.settings.monitor`
  *   e.g., monitor = "eDP-1,2560x1600@60,0x0,2"; for 2x scale or 1.5 for more space.
*/
_: {
  wayland.windowManager.hyprland.enable = true;

  programs.firefox.enable = true;
  stylix.targets.firefox.profileNames = [ "mark" ];
  # programs.kitty.enable = true;
  programs.ghostty.enable = true;
}
