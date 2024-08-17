{
  pkgs,
  lib,
  self,
  generalModules,
  hostname,
  platform,
  stateVersion,
  stateVersionDarwin,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  currentStateVersion =
    if isDarwin
    then stateVersionDarwin
    else stateVersion;
  machineConfigurationPath = "${self}/system/machine/${hostname}";
  doesMachineConfigurationPathExist = builtins.pathExists machineConfigurationPath;
in {
  imports =
    [
      "${generalModules}"
    ]
    ++ lib.optional doesMachineConfigurationPathExist machineConfigurationPath;

  config = {
    system.stateVersion = currentStateVersion;
    nixpkgs.hostPlatform = platform;

    feltnerm.nix.enable = true;
  };
}
