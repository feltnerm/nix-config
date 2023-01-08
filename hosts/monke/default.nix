{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./filesystem.nix
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    feltnerm = {
      config = {
        fonts.enable = true;
      };

      documentation.enable = true;

      gui.enable = true;

      hardware = {
        bluetooth.enable = true;
        cpu = {
          enableMicrocode = true;
          vendor = "intel";
        };
        display.enableHighResolutionDisplay = true;
        ssd.enable = true;
      };

      networking = {
        enableNetworkManager = true;
        preferExplicitNetworkAccess = true;
        interfaces = ["wlp2s0"];
      };

      security = {
        enable = true;
      };

      services = {
        openssh.enable = true;
      };
    };

    # for system zsh autocompletion
    #environment.pathsToLink = ["/share/zsh"];

    system.copySystemConfiguration = false;
    system.stateVersion = "22.05";

    # TODO move to module:
    # gui
    #environment.systemPackages = with pkgs; [
    #  alacritty
    #];
  };
}
