{
  lib,
  pkgs,
  ...
}:
{
  config.den.aspects.features.provides.laptop = {
    nixos = {
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

      environment.systemPackages = lib.mkDefault (
        with pkgs;
        [
          blueman
          brightnessctl
          powertop
        ]
      );
    };
  };
}
