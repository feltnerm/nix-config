/**
  Settings and packages available to all home-manager profiles
*/

{
  pkgs,
  lib,
  inputs,
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
    ./stylix.nix
    ./zsh.nix

    ./options.nix
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
        selfPkgs = inputs.self.packages.${pkgs.system};
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
