/**
  * home-manager GUI config for virtmark-gui
*/
_: {
  wayland.windowManager.hyprland.enable = true;
  programs.firefox.enable = true;
  stylix.targets.firefox.profileNames = [ "mark" ];
  programs.ghostty.enable = true;
}
