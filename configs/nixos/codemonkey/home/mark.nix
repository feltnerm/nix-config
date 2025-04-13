/**
  * home-manager gui config (for nixos)
*/
_: {
  wayland.windowManager.hyprland.enable = true;

  programs.firefox.enable = true;
  stylix.targets.firefox.profileNames = [ "mark" ];
  # programs.kitty.enable = true;
  programs.ghostty.enable = true;

}
