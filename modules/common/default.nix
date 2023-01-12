{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm;
in {
  # imports = [
  #   ./boot.nix
  #   ./gui.nix
  #   ./nix.nix
  #   ./networking.nix
  #   ./nix.nix
  # ];

  # docs
  options.feltnerm.documentation = {
    enable = lib.mkOption {
      description = "Enable building documentation.";
      default = true;
    };
  };

  # locale
  options.feltnerm.locale = {
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
  options.feltnerm.nix = {
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
  options.feltnerm.config.fonts = {
    enable = lib.mkOption {
      description = "Enable pretty fonts.";
      default = false;
    };
  };

  # gui
  options.feltnerm.gui = {
    enable = lib.mkOption {
      description = "Enable desktop GUI.";
      default = false;
    };
  };

  config = {
    time.timeZone = cfg.locale.timezone;
    environment = {
      # TODO only add whichever is enabled
      pathsToLink = ["/share/bash-completion" "/share/zsh"];
      variables = {
        EDITOR = "vim";
        # TODO man, less, etc with colors
      };

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
        auto-optimise-store = true;
        allowed-users = cfg.nix.allowedUsers;
        trusted-users = cfg.nix.trustedUsers;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://feltnerm.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
        ];
      };
    };

    nixpkgs.config = {
      inherit (cfg.nix) allowBroken;
      inherit (cfg.nix) allowUnfree;
    };

    programs.zsh.enable = true;

    fonts = lib.mkIf cfg.config.fonts.enable {
      fonts = with pkgs; [
        comfortaa
        comic-neue
        fira
        fira-code
        fira-code-symbols
        ibm-plex
        inter
        iosevka
        iosevka
        jetbrains-mono
        lato
        material-design-icons
        nerdfonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        powerline-fonts
        roboto
        source-sans
        twemoji-color-font
        work-sans
        (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
      ];
    };
  };
}
