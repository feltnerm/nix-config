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

  options.feltnerm = {
    enable = lib.mkEnableOption "feltnerm";
    theme = lib.mkOption {
      description = "theme";
      default = "gruvbox-dark-hard";
    };
  };

  config = lib.mkIf cfg.enable {

    services.yubikey-agent.enable = true;

    stylix = {
      base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
      polarity = lib.mkDefault "dark";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
      };
    };

    programs = {
      bat.enable = lib.mkDefault true;
      btop = {
        enable = lib.mkDefault true;
        settings = {
          vim_keys = true;
        };
      };
      dircolors.enable = lib.mkDefault true;
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
      nixvim.enable = lib.mkDefault true;
      ranger.enable = lib.mkDefault true;
      readline.enable = lib.mkDefault true;
      ripgrep.enable = lib.mkDefault true;
      ssh.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      #wezterm.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;

      atuin = {
        enable = lib.mkDefault true;
        daemon.enable = lib.mkDefault true;
        settings = {
          invert = true;
          inline_height = 36;
          search_mode = "skim";
          style = "compact";
          enter_accept = false; # do not immediately execute a command
          filter_mode_shell_up_key_binding = "directory"; # up-arrow searches current dir if it is a .git directory
          keymap_mode = "vim-normal";
        };
      };

      direnv = {
        enable = lib.mkDefault true;
        nix-direnv.enable = true;
      };

      nix-index.enable = lib.mkDefault true;

      starship = {
        enable = lib.mkDefault true;
        settings = {
          add_newline = true;
        };
      };
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
        pkgs.ranger
        pkgs.nnn

        # networking
        pkgs.curl
        pkgs.mosh
        pkgs.mtr
        pkgs.openssl
        pkgs.openvpn
        pkgs.prettyping
        pkgs.rclone
        # pkgs.rsync
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

        # history
        pkgs.zoxide

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
