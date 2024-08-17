{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.documentation;
in {
  options.feltnerm.documentation = {
    enable = lib.mkEnableOption "documentation";
  };

  config = lib.mkIf cfg.enable {
    documentation = {
      enable = true;
      man = {
        enable = true;
        generateCaches = true;
      };
      info.enable = true;
      dev.enable = true;
      nixos.enable = true;
    };
  };
}
