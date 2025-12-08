{ pkgs, ... }:
{
  home.stateVersion = "24.05";

  programs.bash.enable = true;
  home.packages = with pkgs; [ cowsay ];
}
