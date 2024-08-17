{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.feltnerm.users;
in {
  options.feltnerm.users = {
    enable = lib.mkEnableOption "users";
    shell = lib.mkPackageOption pkgs "zsh" {};
  };

  config = lib.mkIf cfg.enable {
    users = {
      # mutableUsers = false; # FIXME use immutable users
      users = {
        ${username} = {
          uid = 1000;
          isNormalUser = true;
          description = "${username}";
          inherit (cfg) shell;
          createHome = true;
          home = "/home/${username}";
          initialPassword = "spanky"; # FIXME used hashed passwords
          extraGroups = [
            "wheel"
            "docker"
            "disk"
            "input"
          ];
        };

        # TODO root
        # root = {
        #   shell = cfg.rootShell; # FIXME disable root
        # };
      };
    };
  };
}
