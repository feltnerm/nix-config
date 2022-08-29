{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ./boot.nix
    ./filesystem.nix
    ./hardware.nix
    ./networking.nix
  ];

  config = {
    feltnerm = {
      # users = {
      #   mark = {
      #     name = "mark";
      #     groups = ["users" "wheel" "networkmanager"];
      #     uid = 1000;
      #     shell = pkgs.zsh;
      #   };

      #   kram = {
      #     name = "kram";
      #     uid = 1001;
      #     groups = ["users" "wheel"];
      #     shell = pkgs.zsh;
      #   };
      # };
      hardware = {
        bluetooth.enable = true;
        cpu = {
          enableMicrocode = true;
          vendor = "intel";
        };
        display.enableHighResolutionDisplay = true;
        ssd.enable = true;
      };

      system = {
        documentation.enable = true;
        networking = {
          enableNetworkManager = true;
          preferExplicitNetworkAccess = true;
          interfaces = ["wlp2s0"];
        };
        nix = {
          enableFlake = true;
        };
      };

      security = {
        enable = true;
      };

      config = {
        fonts.enable = true;
      };

      services = {
        openssh.enable = true;
      };
    };

    # for system zsh autocompletion
    #environment.pathsToLink = ["/share/zsh"];

    system.copySystemConfiguration = false;
    system.stateVersion = "22.05";
  };
}
