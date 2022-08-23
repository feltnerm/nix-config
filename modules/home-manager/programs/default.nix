{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.programs;
in {
  imports = [
    ./git.nix
    ./gpg.nix
    ./readline.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
