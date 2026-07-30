{ lib, ... }:
let
  cfg = {
    # TODO: Make this configurable rather than hardcoded
    username = "mark";
    hashedPassword = "$6$2NK82jaDKvjvsrCb$ob7K1mkNsBKy75a4aB5kzNFtQt1QSvlRTPeLlLwAkgPfp2eAgIfLds147MflimRdbHP8ErNoOkG9pUMFNoKua0";
  };
in
{
  config.den.aspects.features.provides.user-hashed = {
    nixos.users.users.${cfg.username}.initialHashedPassword = cfg.hashedPassword;
  };

  config.den.aspects.features.provides.user-groups-gui = {
    nixos.users.users.${cfg.username}.extraGroups = [
      "audio"
      "video"
    ];
  };

  config.den.aspects.features.provides.user-groups-full = {
    nixos.users.users.${cfg.username}.extraGroups = [
      "audio"
      "disk"
      "input"
      "network"
      "video"
      "uinput"
    ];
  };

  config.feltnerm.yubikey.enable = true;
}