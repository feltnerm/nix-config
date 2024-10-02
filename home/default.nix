{
  self,
  pkgs,
  lib,
  inputs,
  homeProfiles,
  homeModules,
  generalModules,
  hostname,
  platform,
  username,
  stateVersion,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin;
  isRoot =
    if (username == "root")
    then true
    else false;
  homeDirectory =
    if isDarwin
    then "/Users/${username}"
    else if isRoot
    then "/root"
    else "/home/${username}";
  userConfigurationPath = "${self}/home/user/${username}";
  userConfigurationPathExist = builtins.pathExists userConfigurationPath;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs self homeProfiles homeModules generalModules hostname username stateVersion platform;
    };

    users.${username} = {
      imports =
        [
          "${generalModules}"
          "${homeModules}"
          "${homeProfiles}"
        ]
        ++ lib.optional userConfigurationPathExist userConfigurationPath;

      config = {
        programs.home-manager.enable = true;
        home = {
          inherit username;
          inherit stateVersion;
          inherit homeDirectory;
        };
      };
    };
  };
}
