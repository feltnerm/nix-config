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
    ./atuin.nix
    ./editorconfig.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./hyprland.nix
    ./nixvim.nix
    ./readline.nix
    ./stylix.nix
    ./zsh.nix
  ];

  options.feltnerm = {
    enable = lib.mkEnableOption "feltnerm";
    theme = lib.mkOption {
      description = "theme";
      default = "gruvbox-dark-hard";
    };
  };

  config = {
    programs = {
      home-manager.enable = lib.mkForce true;

      bash.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
    };

    home.packages = with pkgs; [
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
