{
  config,
  lib,
  pkgs,
  outputs,
  ...
}: let
  cfg = config.feltnerm;
in {
  # docs
  options.feltnerm = {
    documentation = {
      enable = lib.mkOption {
        description = "Enable building documentation.";
        default = true;
      };
    };

    # locale
    locale = {
      timezone = lib.mkOption {
        description = "System timezone";
        default = "America/Chicago";
      };

      keymap = lib.mkOption {
        description = "System keymap";
        default = "us";
      };
    };
    # nix
    nix = {
      enableFlake = lib.mkOption {
        description = "Enable nix flake support";
        default = true;
      };

      allowBroken = lib.mkOption {
        description = "Allow broken nix pkgs.";
        type = lib.types.bool;
        default = false;
      };

      allowUnfree = lib.mkOption {
        description = "Break Stallman's heart.";
        type = lib.types.bool;
        default = true;
      };

      allowedUsers = lib.mkOption {
        description = "Users to give access to nix to.";
        default = [];
      };

      trustedUsers = lib.mkOption {
        description = "Users to give enhanced access to nix to.";
        default = [];
      };
    };

    # fonts
    config.fonts = {
      enable = lib.mkOption {
        description = "Enable pretty fonts.";
        default = false;
      };
    };

    # gui
    gui = {
      enable = lib.mkOption {
        description = "Enable desktop GUI.";
        default = false;
      };
    };
  };

  config = {
    time.timeZone = cfg.locale.timezone;
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
        exa
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

    documentation = lib.mkIf cfg.documentation.enable {
      enable = true;
      man = {
        enable = true;
      };
      info.enable = true;
    };

    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than 4d";
      };
      # package = pkgs.nixUnstable;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = lib.mkDefault false;
        allowed-users = cfg.nix.allowedUsers;
        trusted-users = cfg.nix.trustedUsers;
        substituters = [
          "https://feltnerm.cachix.org"
        ];

        trusted-public-keys = [
          "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
        ];
      };
    };

    nixpkgs.overlays = builtins.attrValues outputs.overlays;
    nixpkgs.config = {
      inherit (cfg.nix) allowBroken;
      inherit (cfg.nix) allowUnfree;
    };

    programs.zsh.enable = true;

    fonts = lib.mkIf cfg.config.fonts.enable {
      fonts = with pkgs; [
        # sans fonts
        comic-neue
        source-sans

        (nerdfonts.override {
          fonts = [
            "Hack"
            "IBMPlexMono"
            "Iosevka"
            "JetBrainsMono"
          ];
        })
      ];
    };
  };
}
