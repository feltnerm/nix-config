{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./cli
    ./config
    ./programs
    ./services
    ./ui
  ];

  config = {
    systemd.user.startServices = true;

    programs = {
      home-manager.enable = true;
      starship = {
        enable = true;
        settings = {
          add_newline = true;
        };
      };
    };

    services.home-manager.autoUpgrade = {
      enable = lib.mkDefault false;
      frequency = "daily";
    };

    home = {
      enableNixpkgsReleaseCheck = true;
      shellAliases = {
        cp = "cp -i"; # write error instead of overwriting
        cpv = "rsync -pogr --progress";
        cpp = "rsync -Wavp --human-readable --progress $1 $2";
        mv = "mv -i";
        rm = "rm -ir";
        weather = "curl wttr.in";
        oracow = "fortune | cowsay";
      };

      packages = with pkgs; [
        ack
        bat
        direnv
        eza
        fd
        gawk
        readline
        ripgrep
        ripgrep-all
        # vim

        fpp

        hexyl
        httpie

        lynx

        # processors
        gawk

        # process management
        htop
        killall
        lnav
        lsof
        #pidof

        # networking
        curl
        mosh
        mtr
        openssl
        openvpn
        rclone
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

        # my scripts and packages
        feltnerm.chuckscii
        feltnerm.greet
        feltnerm.screensaver
        feltnerm.year-progress
      ];

      file = {
        ".hushlogin" = {
          text = "";
        };

        ".editorconfig" = {
          text = ''
            # editorconfig.org
            root = true

            [*]
            charset = utf-8
            end_of_line = lf
            trim_trailing_whitespace = true
            insert_final_newline = true

            [*.{json,yaml,yml,toml,tml}]
            indent_style = space
            indent_size = 2

            [Makefile]
            indent_style = tab
          '';
        };
      };
    };
  };
}
