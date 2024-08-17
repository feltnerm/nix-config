{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.feltnerm.environment;
in {
  options.feltnerm.environment = {
    enable = lib.mkEnableOption "environment";
  };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
    };

    environment.sessionVariables = {
      FLAKE = "/home/${username}/code/nixos-config"; # TODO/FIXME
    };
  };
}
