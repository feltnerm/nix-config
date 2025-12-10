{ pkgs, ... }:
{
  users.users.mark = {
    description = "Mark Feltner";
    shell = pkgs.zsh;
    home = "/home/mark";
    extraGroups = [
      "wheel"
    ];
  };
}
