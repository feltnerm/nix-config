{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.profiles.minimal;
in {
  config = lib.mkIf cfg.enable {
    feltnerm = {
      programs = {
        fzf.enable = true;
        neovim.enable = true;
        nix.enable = true;
        readline.enable = true;
        ssh.enable = true;
        tmux.enable = true;
        zsh.enable = true;
      };
    };

    programs = {
      bat = {
        enable = true;
        config.theme = "base16";
      };
      dircolors.enable = true;
      home-manager.enable = true;
      htop.enable = true;
      info.enable = true;
      jq.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      eza = {
        enable = true;
      };

      fzf = {
        enable = true;
        tmux = {
          #enableShellIntegration = true;
        };
      };

      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };

      starship = {
        enable = true;
        settings = {
          add_newline = true;
        };
      };
    };

    xdg = {
      enable = lib.mkDefault true;
      userDirs = {
        enable = false;
        createDirectories = true;
      };
    };

    home = {
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        cp = "cp -i"; # write error instead of overwriting
        cpv = "${pkgs.rsync}/bin/rsync -pogr --progress";
        cpp = "${pkgs.rsync}/bin/rsync -Wavp --human-readable --progress $1 $2";
        mv = "mv -i";
        rm = "rm -ir";
        weather = "${pkgs.curl}/bin/curl wttr.in";
        oracow = "${pkgs.fortune}/bin/fortune | ${pkgs.cowsay}/bin/cowsay";

        # nix aliases
        n = "${pkgs.nix}/bin/nix";
        nd = "${pkgs.nix}/bin/nix develop -c $SHELL";
        ndc = "${pkgs.nix}/bin/nix develop -c";
        ns = "${pkgs.nix}/bin/nix shell";
        nsn = "${pkgs.nix}/bin/nix shell nixpkgs#";
        nb = "${pkgs.nix}/bin/nix build";
        nbn = "${pkgs.nix}/bin/nix build nixpkgs#";
        nf = "${pkgs.nix}/bin/nix flake";
      };

      # don't display login message
      file.".hushlogin" = {
        text = "";
      };

      packages = with pkgs; [
        zsh
        vim
        git
        man

        # shell utils
        ack
        fd
        fpp
        readline
        ripgrep
        ripgrep-all

        hexyl
        httpie

        lynx

        # process management
        bottom
        killall
        lnav
        lsof
        #pidof

        # processors
        gawk

        # networking
        curl
        mosh
        mtr
        openssl
        openvpn
        prettyping
        rclone
        rsync
        speedtest-cli
        sshfs
        wget

        # utils
        tree
        unrar
        unzip

        # fun
        cowsay
        figlet
        fortune
        lolcat
        neofetch
        toilet

        # my scripts and packages
        feltnerm.chuckscii
        feltnerm.greet
        feltnerm.screensaver
        feltnerm.year-progress
      ];
    };
  };
}
