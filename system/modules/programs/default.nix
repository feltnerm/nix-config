{
  config,
  lib,
  pkgs,
  hostModules,
  ...
}: let
  cfg = config.feltnerm.programs;
  hostProgramModulesPath = "${hostModules}/programs";
in {
  options.feltnerm.programs = {
    enable = lib.mkEnableOption "programs";

    dconf = {
      enable = lib.mkEnableOption "dconf";
    };
  };

  imports = [
    "${hostProgramModulesPath}/gnupg"
    "${hostProgramModulesPath}/home-manager"
    "${hostProgramModulesPath}/nix-helper"
    "${hostProgramModulesPath}/xdg-portal"
  ];

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    programs.dconf.enable = cfg.dconf.enable;

    environment.systemPackages = with pkgs; [
      git
      vim
      zsh

      # process management
      bottom
      htop
      killall
      lsof
      #pidof

      curl
      wget
      file
      zip
      unzip
      unrar

      # Network
      # TODO
      #inetutils
      #wireguard-tools
      #dig
      #nmap
      #dnsutils
      #iperf3
      #mtr
      #ipcalc
      #cacert

      # Hardware utils
      # TODO
      # glxinfo
      # pciutils
      # usbutils
      # powertop
      # lm_sensors
      # strace
      # ltrace
      # lsof
      # sysstat
      # cpufetch
      # sbctl

      # nix
      home-manager
    ];
  };
}
