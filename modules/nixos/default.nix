{
  config,
  lib,
  ...
}: {
  imports = [
    ./config
    ./gui.nix
    ./hardware
    ./networking.nix
    ./programs
    ./security
    ./services
    ./system.nix
  ];

  config = {
    documentation = lib.mkIf config.feltnerm.documentation.enable {
      dev.enable = true;
      man.generateCaches = true;
      nixos.enable = true;
    };

    # Give admins enhanced nix privs
    nix.settings.trusted-users = ["@wheel"];
  };
}
