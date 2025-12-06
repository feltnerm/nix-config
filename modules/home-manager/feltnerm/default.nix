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

      packages =
        let
          # base always-installed packages (minimal profile)
          base = [
            pkgs.zsh
            pkgs.vim
            pkgs.git
            pkgs.man
            pkgs.readline
            pkgs.ripgrep
          ];

          # development tools
          developmentPkgs = [
            pkgs.ack
            pkgs.fd
            pkgs.fpp
            pkgs.chezmoi
            pkgs.bottom
            pkgs.killall
            pkgs.lsof
            pkgs.glances
            pkgs.gawk
            pkgs.tree
            pkgs.unrar
            pkgs.unzip
            pkgs.poppler
            pkgs.imagemagick
          ];

          # file browsers
          fileBrowsers = [
            pkgs.mc
            pkgs.ncdu_1
            pkgs.nnn
          ];

          # networking tools
          networkingPkgs = [
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
            pkgs.hexyl
            pkgs.httpie
            pkgs.lynx
            pkgs.surfraw
          ];

          # fun/toys
          funPkgs = [
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
          ];

          yubikeyPkgs = [
            pkgs.yubikey-agent
            pkgs.yubikey-manager
            pkgs.yubikey-personalization
          ];

          # profile presets
          preset =
            {
              minimal = base;
              standard = base ++ developmentPkgs ++ fileBrowsers;
              full = base ++ developmentPkgs ++ fileBrowsers ++ networkingPkgs ++ funPkgs ++ yubikeyPkgs;
            }.
            ${cfg.profile or (if pkgs.stdenv.isDarwin then "full" else "standard")};

        in
          preset
          ++ lib.optionals cfg.packages.development developmentPkgs
          ++ lib.optionals cfg.packages.networking networkingPkgs
          ++ lib.optionals cfg.packages.fun funPkgs
          ++ lib.optionals cfg.packages.yubikey yubikeyPkgs
          # platform-specific extras
          ++ lib.optionals pkgs.stdenv.isDarwin [ ]
           ++ lib.optionals pkgs.stdenv.isLinux [ ]
          # custom local packages via pkgs-by-name
          ++ lib.optionals cfg.packages.custom (
            let byname = pkgs.by-name or { }; in
            builtins.filter (p: p != null) [
              (byname.greet or null)
              (byname.chuckscii or null)
              (byname.screensaver or null)
              (byname.year-progress or null)
            ]
          );
    };
  };
}
