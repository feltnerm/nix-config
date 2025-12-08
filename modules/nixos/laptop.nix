{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.laptop;
in
{
  options.feltnerm.laptop = {
    enable = lib.mkEnableOption "laptop power management and utilities";
  };

  config = lib.mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = lib.mkDefault "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = lib.mkDefault "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkDefault "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = lib.mkDefault "power";
      };
    };

    services.thermald.enable = true;
    programs.light.enable = true;

    environment.systemPackages = lib.mkDefault (
      with pkgs;
      [
        blueman
        light
        brightnessctl
        powertop
      ]
    );
  };
}
