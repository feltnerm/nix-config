{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.programs;
in {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./readline.nix
    ./ssh.nix
    ./tmux.nix
    ./wayland.nix
    ./zsh.nix
  ];
}
