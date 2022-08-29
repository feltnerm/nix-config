_: {
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./config
    ./programs
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  systemd.user.startServices = true;

  programs = {
    home-manager.enable = true;
  };

  home.enableNixpkgsReleaseCheck = true;

  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };

  home.packages = with pkgs; [
    ack
    fd
    ripgrep

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
  ];
}
