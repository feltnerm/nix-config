{ pkgs, ... }:
{
  users.users.mark = {
    isNormalUser = true;
    home = "/home/mark";
    description = "Mark Feltner";
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # Allow wheel group sudo without password for dev convenience
  security.sudo.wheelNeedsPassword = false;
}
