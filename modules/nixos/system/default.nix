{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.system;
in {
  imports = [
    ./boot.nix
    ./networking.nix
    ./nix.nix
  ];

  options.feltnerm.system.documentation = {
    enable = lib.mkOption {
      description = "Enable building documentation.";
      default = true;
    };
  };

  options.feltnerm.system.locale = {
    locale = lib.mkOption {
      description = "Locale for the system.";
      default = "en_US.UTF-8";
    };

    timezone = lib.mkOption {
      description = "System timezone";
      default = "America/Chicago";
    };

    keymap = lib.mkOption {
      description = "System keymap";
      default = "us";
    };
  };

  config = {
    i18n.defaultLocale = cfg.locale.locale;
    time.timeZone = cfg.locale.timezone;

    console = {
      #font = "Lat2-Terminus16";
      # keyMap = cfg.locale.keymap;
      useXkbConfig = true; # use xkbOptions in tty.
    };

    system.copySystemConfiguration = false;
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      allowReboot = false;
    };

    systemd.enableEmergencyMode = false;
    # TODO wat
    # services.journald.extraConfig = ''
    #   SystemMaxUse=100M
    #   MaxFileSec=7day
    # '';

    environment = {
      sessionVariables = {
        EDITOR = "vim";
        # TODO man, less, etc with colors
      };

      shells = [pkgs.zsh pkgs.bash];

      # TODO system and/or home-manager packages?
      systemPackages = with pkgs; [
        zsh
        vim
        git

        # shell utils
        ack
        bat
        exa
        fd
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
        rsync
        speedtest-cli
        wget

        # utils
        tree
        unrar
        unzip

        # nix
        niv
        nixfmt

        # fun
        cowsay
        figlet
        fortune
        neofetch
        toilet
      ];
    };

    documentation = lib.mkIf cfg.documentation.enable {
      enable = true;
      dev.enable = true;
      man = {
        enable = true;
        generateCaches = true;
      };
      info.enable = true;
      nixos.enable = true;
    };
  };
}
