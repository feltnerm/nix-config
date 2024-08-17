{hostModules, ...}: let
  hostServicesModulesPath = "${hostModules}/services";
in {
  imports = [
    "${hostServicesModulesPath}/greetd"
    "${hostServicesModulesPath}/hyprland"
    "${hostServicesModulesPath}/openssh"
    "${hostServicesModulesPath}/polkit"
  ];
}
