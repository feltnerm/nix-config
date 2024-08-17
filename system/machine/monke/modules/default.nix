{
  self,
  hostname,
  modulesPath,
  ...
}: let
  machineModulesPath = "${self}/system/machine/${hostname}/modules";
in {
  imports = [
    # TODO added by nix
    (modulesPath + "/installer/scan/not-detected.nix")
    "${machineModulesPath}/hardware"
  ];
}
