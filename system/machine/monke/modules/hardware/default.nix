{
  self,
  hostname,
  ...
}: let
  machineHardwareModulesPath = "${self}/system/machine/${hostname}/modules/hardware";
in {
  imports = [
    "${machineHardwareModulesPath}/boot"
    "${machineHardwareModulesPath}/extra-hardware"
    "${machineHardwareModulesPath}/filesystem"
    # "${machineHardwareModulesPath}/graphics-card"
    # "${machineHardwareModulesPath}/impermanence"
    # "${machineHardwareModulesPath}/kernel"
    # "${machineHardwareModulesPath}/sound"
  ];
}
