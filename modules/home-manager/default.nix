/**
  Settings and packages available to all home-manager profiles
*/

{ pkgs, lib, ... }:
{
  imports = [
    ./feltnerm
    ./fzf
    ./tmux

    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    # ./hyprland.nix
    ./nixvim.nix
    ./readline.nix
    ./zsh.nix
  ];

  config = {
    programs = {
      home-manager.enable = lib.mkForce true;

      bash.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
    };

    home.packages = with pkgs; [
      home-manager
      nix-health
      nix-tree
    ];

    systemd.user.startServices = lib.mkDefault true;

    services.home-manager.autoUpgrade = {
      enable = lib.mkDefault false;
      frequency = lib.mkDefault "weekly";
    };

    home.enableNixpkgsReleaseCheck = lib.mkDefault true;

  };
}
