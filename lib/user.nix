_: {
  nixosUserFactory = {pkgs, ...}: {
    username,
    uid ? 1000,
    isSudo ? false,
    initialPassword ? "spanky",
    shell ? "bashInteractive",
    isTrusted ? false,
  }: let
    groups =
      if isSudo
      then [
        "wheel"
        "audio"
        "disk"
        "input"
        "network"
        "networkmanager"
        "systemd-journal"
        "video"
      ]
      else [];

    userShell = pkgs."${shell}";

    isNormalUser = true;
    isSystemUser = false;
  in {
    users.users."${username}" = {
      inherit uid isNormalUser isSystemUser;
      shell = userShell;
      initialPassword = "${initialPassword}";
      extraGroups = groups;
      createHome = true;
      home = "/home/${username}";
    };

    nix.settings.trusted-users =
      if isTrusted
      then [username]
      else [];
  };
}
