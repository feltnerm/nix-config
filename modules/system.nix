# shared settings between Nix "systems"
# (i.e., non-home-manager systems like nix-darwin or a NixOS system)
# contains options that are available for both.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm;
in {
  # nix
  options.feltnerm.nix = {
    allowedUsers = lib.mkOption {
      description = "Users to give access to nix to.";
      default = [];
    };

    trustedUsers = lib.mkOption {
      description = "Users to give enhanced access to nix to.";
      default = [];
    };
  };

  config = {
    # shared locale settings
    time.timeZone = cfg.locale.timezone;

    # shared documentations settings
    documentation = lib.mkIf cfg.documentation.enable {
      enable = true;
      man = {
        enable = true;
      };
      info.enable = true;
    };

    # shared nix settings
    nix = {
      gc.automatic = lib.mkDefault true;
      settings = {
        # FIXME this one is buggy?
        auto-optimise-store = lib.mkDefault false;

        # enable nix flake support
        experimental-features = ["nix-command" "flakes"];

        # allow other users to user and/or manage nix
        trusted-users = cfg.nix.trustedUsers;
        allowed-users = cfg.nix.allowedUsers;

        # use shared build caches
        # substituters = [
        #   "https://feltnerm.cachix.org"
        # ];

        # trusted-public-keys = [
        #   "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
        # ];
      };
    };

    # shared environment settings
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
        direnv
        eza
        fd
        fpp
        gawk
        jq
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

    programs = {
      zsh.enable = true;
    };
  };
}
