{config, ...}: let
  cfg = config.feltnerm.config;
in {
  imports = [
    ./xdg.nix
  ];
}
