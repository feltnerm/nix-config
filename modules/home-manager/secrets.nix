{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.feltnerm.secrets;
in
{
  options.feltnerm.secrets = {
    enable = lib.mkEnableOption "Enable user-level secrets access";
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (osConfig ? age && osConfig.age ? package) [ osConfig.age.package ];
  };
}
