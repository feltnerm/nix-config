/**
  * home-manager GUI config for livecd-gui
*/
_: {
  wayland.windowManager.hyprland.enable = true;
  programs.firefox.enable = true;
  stylix.targets.firefox.profileNames = [ "mark" ];
  programs.ghostty.enable = true;
}
