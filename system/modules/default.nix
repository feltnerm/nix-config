{hostModules, ...}: {
  imports = [
    "${hostModules}/docs"
    "${hostModules}/environment"
    "${hostModules}/fonts"
    "${hostModules}/hardware"
    "${hostModules}/locale"
    "${hostModules}/networking"
    "${hostModules}/programs"
    "${hostModules}/security"
    "${hostModules}/services"
    "${hostModules}/users"
    "${hostModules}/virtualization"
  ];

  config = {
    system = {
      copySystemConfiguration = false;
    };
    systemd.enableEmergencyMode = false;
    boot.tmp.cleanOnBoot = true;
    # TODO keymap and map caps to escape
    console.useXkbConfig = true;
  };
}
