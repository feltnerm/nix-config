/**
  Settings and packages available to all home-manager profiles
*/

{
  pkgs,
  lib,
  ...
}:
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

    ./zsh.nix

    ./options.nix
    ./gui.nix
  ];

  config = {
    programs = {
      home-manager.enable = lib.mkForce true;

      bash.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
    };

    home.packages =
      with pkgs;
      let
        selfPkgs = {
          greet = pkgs.callPackage ../../pkgs/greet.nix { };
          nlsp = pkgs.callPackage ../../pkgs/nlsp.nix { };
          screensaver = pkgs.callPackage ../../pkgs/screensaver/package.nix { };
          year-progress = pkgs.callPackage ../../pkgs/year-progress/package.nix { };
          chuckscii = pkgs.callPackage ../../pkgs/chuckscii/package.nix { };
        };
      in
      [
        nix-health
        nix-tree

        selfPkgs.greet
        selfPkgs.nlsp
        selfPkgs.screensaver
        selfPkgs.year-progress
        selfPkgs.chuckscii
      ];

    systemd.user.startServices = lib.mkDefault pkgs.stdenv.isDarwin;

    services.home-manager.autoUpgrade = {
      enable = lib.mkDefault false;
      frequency = lib.mkDefault "weekly";
    };

    home.enableNixpkgsReleaseCheck = lib.mkDefault true;
  };
}
