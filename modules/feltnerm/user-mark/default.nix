_: {
  config.den.aspects.features.provides.mark-user-hashed = {
    nixos.users.users.mark.initialHashedPassword =
      "$6$2NK82jaDKvjvsrCb$ob7K1mkNsBKy75a4aB5kzNFtQt1QSvlRTPeLlLwAkgPfp2eAgIfLds147MflimRdbHP8ErNoOkG9pUMFNoKua0";
  };

  config.den.aspects.features.provides.mark-groups-gui = {
    nixos.users.users.mark.extraGroups = [
      "audio"
      "video"
    ];
  };

  config.den.aspects.features.provides.mark-groups-full = {
    nixos.users.users.mark.extraGroups = [
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
