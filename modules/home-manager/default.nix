{
  pkgs,
  config,
  lib,
  outputs,
  ...
}: let
  cfg = config.feltnerm.home-manager;
in {
  options.feltnerm.home-manager = {
    enableAutoUpgrade = lib.mkOption {
      description = "Enable auto upgrade of home-manager";
      default = true;
    };
  };

  imports = [
    ./config
    ./programs
    ./services
  ];

  config = {
    nixpkgs.overlays = [outputs.overlays];
    nixpkgs.config = {
      allowUnfree = true;
    };

    systemd.user.startServices = true;

    programs = {
      home-manager.enable = true;
      # TODO rice my setup
      starship = {
        enable = true;
        settings = {
          add_newline = true;
        };
      };
    };

    home.enableNixpkgsReleaseCheck = true;

    services.home-manager.autoUpgrade = {
      enable = cfg.enableAutoUpgrade;
      frequency = "daily";
    };

    home.packages = with pkgs; [
      ack
      bat
      direnv
      exa
      fd
      gawk
      readline
      ripgrep
      ripgrep-all
      # vim

      fpp

      hexyl
      httpie

      lynx

      # processors
      gawk

      # process management
      htop
      killall
      lsof
      #pidof

      # networking
      curl
      mosh
      mtr
      openssl
      openvpn
      rclone
      rsync
      speedtest-cli
      wget

      # utils
      tree
      unrar
      unzip

      # fun
      cowsay
      figlet
      fortune
      neofetch
      toilet

      feltnerm.greet
      feltnerm.screensaver
    ];
  };
}
