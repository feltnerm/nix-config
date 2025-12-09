{ pkgs, ... }:
{
  users.users.mark = {
    isNormalUser = true;
    createHome = true;
    home = "/home/mark";
    description = "Mark Feltner";
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
