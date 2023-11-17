{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix

    ./programs
    ./profiles
    ./services
  ];

  # settings and packages available to all home-manager profiles

  config = {
    systemd.user.startServices = lib.mkDefault true;

    services.home-manager.autoUpgrade = {
      enable = false;
      frequency = "daily";
    };

    xdg = {
      enable = lib.mkDefault true;
      userDirs = {
        enable = false;
        createDirectories = true;
      };
    };

    feltnerm = {
      programs = {
        fzf.enable = true;
        git.enable = true;
        gpg.enable = true;
        neovim.enable = true;
        readline.enable = true;
        ssh.enable = true;
        tmux.enable = true;
        zsh.enable = true;
      };
    };

    programs = {
      bat.enable = true;
      dircolors.enable = true;
      home-manager.enable = true;
      htop.enable = true;
      info.enable = true;
      jq.enable = true;
      zsh.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      eza = {
        enable = true;
        enableAliases = true;
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

    home = {
      enableNixpkgsReleaseCheck = true;

      # TODO use `${pkg.blah}/bin` references here
      shellAliases = {
        cat = "bat";
        cp = "cp -i"; # write error instead of overwriting
        cpv = "rsync -pogr --progress";
        cpp = "rsync -Wavp --human-readable --progress $1 $2";
        mv = "mv -i";
        rm = "rm -ir";
        weather = "curl wttr.in";
        oracow = "fortune | cowsay";
      };

      packages = with pkgs; [
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
        ripgrep-all

        hexyl
        httpie

        lynx

        # process management
        bottom
        htop
        killall
        lnav
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

        # nix
        home-manager

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

      # don't display login message
      file.".hushlogin" = {
        text = "";
      };
    };
  };
}
