{ pkgs, ... }:
{
  users.users.mark = {
    initialHashedPassword = "$6$2NK82jaDKvjvsrCb$ob7K1mkNsBKy75a4aB5kzNFtQt1QSvlRTPeLlLwAkgPfp2eAgIfLds147MflimRdbHP8ErNoOkG9pUMFNoKua0";
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
    ];
    shell = pkgs.zsh;
  };
}
