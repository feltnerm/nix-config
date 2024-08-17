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
      zsh
      vim
      git
      man

      # shell utils
      ack
      bat
      direnv
      eza
      fd
      fpp
      readline
      ripgrep

      # process management
      bottom
      htop
      killall
      lsof
      #pidof

      # processors
      gawk
      jq

      # networking
      curl
      mosh
      mtr
      openssl
      prettyping
      rsync
      speedtest-cli
      sshfs
      wget

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

      # utils
      tree
      unrar
      unzip

      # nix
      home-manager
      nix-output-monitor

      # fun
      cowsay
      figlet
      fortune
      lolcat
      neofetch
      toilet
    ];
  };
}
