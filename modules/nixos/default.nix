{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm;
in {
  imports = [
    ../common
    ./gui
    ./hardware
    ./networking.nix
    ./programs
    ./security
    ./services
    ./system.nix
  ];

  config = {
    # nixos specific documentation
    time.timeZone = cfg.locale.timezone;

    documentation = lib.mkIf config.feltnerm.documentation.enable {
      enable = true;
      man = {
        enable = true;
        generateCaches = true;
      };
      dev.enable = true;
      nixos.enable = true;
    };

    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than 4d";
      };
      # Give admins enhanced nix privs
      settings.trusted-users = ["@wheel"];
    };

    environment = {
      pathsToLink = ["/share/bash-completion" "/share/zsh"];

      shells = [pkgs.zsh pkgs.bashInteractive];

      # TODO system and/or home-manager packages?
      systemPackages = with pkgs; [
        zsh
        vim
        git
        man

        # shell utils
        ack
        bat
        eza
        fd
        readline
        ripgrep
        tmux

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

        # utils
        tree
        unrar
        unzip

        # nix
        home-manager

        # fun
        cowsay
        figlet
        fortune
        lolcat
        neofetch
        toilet
      ];
    };
  };
}
