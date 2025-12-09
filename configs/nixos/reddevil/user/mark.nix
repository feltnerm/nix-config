{ pkgs, ... }:
{
  users.users.mark = {
    isNormalUser = true;
    createHome = true;
    group = "mark";
    home = "/home/mark";
    description = "Mark Feltner";
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  users.groups.mark = { };

  # Allow wheel group sudo without password for dev convenience
  security.sudo.wheelNeedsPassword = false;
}
