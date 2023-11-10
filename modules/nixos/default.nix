{
  config,
  lib,
  pkgs,
  outputs,
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
      settings = {
        # experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = lib.mkDefault false;
        # Give admins enhanced nix privs
        trusted-users = ["@wheel"];
        # trusted-users = ["@wheel"] + cfg.nix.trustedUsers;
        allowed-users = cfg.nix.allowedUsers;
        # substituters = [
        #   "https://feltnerm.cachix.org"
        # ];

        # trusted-public-keys = [
        #   "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
        # ];
      };
    };

    nixpkgs = {
      overlays =
        if (outputs ? "overlays")
        then builtins.attrValues outputs.overlays
        else [];
      config = {
        allowUnfree = lib.mkDefault true;
        allowBroken = lib.mkDefault false;
      };
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
