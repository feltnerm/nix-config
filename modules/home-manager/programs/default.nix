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
    ./readline.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
