{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm;
in
{

  imports = [
    ./developer.nix
  ];

  config = lib.mkIf cfg.enable {

    services.yubikey-agent.enable = lib.mkDefault true;

    editorconfig.enable = lib.mkDefault true;

    programs = {
      atuin.enable = lib.mkDefault true;
      bat.enable = lib.mkDefault true;
      btop = {
        enable = lib.mkDefault true;
        settings = {
          vim_keys = true;
        };
      };
      dircolors.enable = lib.mkDefault true;
      direnv = {
        enable = lib.mkDefault true;
        nix-direnv.enable = true;
      };
      eza = {
        enable = lib.mkDefault true;
        icons = lib.mkDefault "auto";
        git = lib.mkDefault true;
      };
      fzf.enable = lib.mkDefault true;
      gh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      gpg.enable = lib.mkDefault true;
      home-manager.enable = lib.mkDefault true;
      htop.enable = lib.mkDefault true;
      info.enable = lib.mkDefault true;
      jujutsu.enable = lib.mkDefault true;
      jq.enable = lib.mkDefault true;
      keychain.enable = lib.mkDefault true;
      nix-index.enable = lib.mkDefault true;
      nixvim.enable = lib.mkDefault true;
      readline.enable = lib.mkDefault true;
      ripgrep.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
      starship = {
        enable = lib.mkDefault true;
        settings = {
          add_newline = true;
        };
      };
      tmux.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };

    xdg = {
      enable = lib.mkDefault true;
      userDirs = {
        enable = lib.mkDefault false;
        createDirectories = lib.mkDefault false;
      };
    };

    home = {
      # don't display login message
      file.".hushlogin" = {
        text = "";
      };

      shellAliases = {
        cp = "cp -i"; # write error instead of overwriting
        mv = "mv -i";
        rm = "rm -ir";

        cpv = "${pkgs.rsync}/bin/rsync -pogr --progress";
        cpp = "${pkgs.rsync}/bin/rsync -Wavp --human-readable --progress $1 $2";

        weather = "${pkgs.curl}/bin/curl wttr.in";
        oracow = "${pkgs.fortune}/bin/fortune | ${pkgs.cowsay}/bin/cowsay";
      };

      packages = [
        pkgs.zsh
        pkgs.vim
        pkgs.git
        pkgs.man

        # shell utils
        pkgs.ack
        pkgs.fd
        pkgs.fpp
        pkgs.readline
        pkgs.ripgrep
        pkgs.ripgrep-all

        pkgs.chezmoi

        # process management
        pkgs.bottom
        pkgs.killall
        #lnav
        pkgs.lsof
        #pidof
        pkgs.glances
        #gotop
        # pkgs.nodePackages.nodemon

        # processors
        pkgs.gawk

        # file browsers
        pkgs.mc # midnight commander
        pkgs.ncdu_1 # FIXME once zig is stable
        pkgs.nnn

        # networking
        pkgs.curl
        pkgs.mosh
        pkgs.mtr
        pkgs.openssl
        pkgs.openvpn
        pkgs.prettyping
        pkgs.rclone
        pkgs.rsync
        pkgs.speedtest-cli
        pkgs.sshfs
        pkgs.trippy
        pkgs.wget

        # http
        pkgs.hexyl
        pkgs.httpie
        pkgs.lynx
        # TODO surfraw configuration
        pkgs.surfraw

        # nix
        pkgs.niv

        # utils
        pkgs.tree
        pkgs.unrar
        pkgs.unzip

        # pdf
        pkgs.poppler

        # image tools
        pkgs.imagemagick

        pkgs.bitwarden-cli
        # yubikey
        pkgs.yubikey-agent
        pkgs.yubikey-manager
        pkgs.yubikey-personalization

        # fun
        pkgs.cowsay
        pkgs.figlet
        pkgs.fortune
        pkgs.lolcat
        pkgs.neofetch
        pkgs.toilet
        pkgs.ascii-image-converter
        pkgs.asciinema
        pkgs.nyancat
        pkgs.yt-dlp

        # my scripts and packages
        # self.legacyPackages."${pkgs.stdenv.hostPlatform.system}".chuckscii
        # self.legacyPackages."${pkgs.stdenv.hostPlatform.system}".greet
        # self.legacyPackages."${pkgs.stdenv.hostPlatform.system}".screensaver
        # self.legacyPackages."${pkgs.stdenv.hostPlatform.system}".year-progress

        # self.packages."${pkgs.stdenv.hostPlatform.system}".feltnerm-nvim

      ];
    };
  };
}
