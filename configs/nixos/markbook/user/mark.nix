{ pkgs, ... }:
{
  users.users.mark = {
    isNormalUser = true;
    createHome = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "audio"
      "disk"
      "input"
      "network"
      "networkmanager"
      "systemd-journal"
      "video"
      "uinput"
    ];
    initialHashedPassword = "$6$2NK82jaDKvjvsrCb$ob7K1mkNsBKy75a4aB5kzNFtQt1QSvlRTPeLlLwAkgPfp2eAgIfLds147MflimRdbHP8ErNoOkG9pUMFNoKua0";
  };
}
