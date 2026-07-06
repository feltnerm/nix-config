{ pkgs, ... }:
{
  imports = [ ../../../../modules/home/mark/home.nix ];

  home.stateVersion = "25.05";

  programs.bash.enable = true;
  home.packages = with pkgs; [ cowsay ];
}
