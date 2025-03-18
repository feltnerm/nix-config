{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.developer;

  /**
    Quick search for a repo and `cd` to its directory
  */
  fzfReposZshExtra = ''
    function c() {
      cd -- $(fzf-repo "$1")
    }
  '';

  /**
    grep git commits
  */
  fzfGitCommits = pkgs.writeShellApplication {
    name = "fzf-git-commits";
    runtimeInputs = [
      pkgs.fzf
      pkgs.git
      pkgs.diff-so-fancy
    ];
    text = "git log --oneline | fzf --multi --preview 'git show {+1} | diff-so-fancy --color'";
  };

  /**
    search for my repos
  */
  fzfRepo = pkgs.writeShellApplication {
    name = "fzf-repo";
    runtimeInputs = [
      pkgs.fzf
      pkgs.eza
    ];
    text = builtins.readFile ./fzf-repo.sh;
  };
in
{
  options.feltnerm.developer = {
    enable = lib.mkEnableOption "developer";
    codeHome = lib.mkOption {
      description = "code directory";
      default = "${config.home.homeDirectory}/code";
    };
    git = {
      username = lib.mkOption {
        default = "";
      };
      email = lib.mkOption {
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zsh.initExtra = lib.mkIf (
        config.programs.zsh.enable && config.programs.fzf.enable
      ) fzfReposZshExtra;

      git = lib.mkIf config.programs.git.enable {
        userName = cfg.git.username;
        userEmail = cfg.git.email;
      };

      jujutsu = lib.mkIf config.programs.jujutsu.enable {
        settings = {
          name = cfg.git.username;
          inherit (cfg.git) email;
        };
      };

      nixvim = {
        plugins = {
          dap.enable = lib.mkDefault true;
          project-nvim.enable = lib.mkDefault true;
          rest.enable = lib.mkDefault true;
        };
      };
    };

    editorconfig = {
      enable = lib.mkDefault true;
      settings = {
        "*" = {
          "charset" = "utf-8";
          "end_of_line" = "lf";
          "trim_trailing_whitespace" = true;
          "insert_final_newline" = true;
        };
        "*.{json,yaml,yml,toml,tml}" = {
          "indent_style" = "space";
          "indent_size" = "2";
        };
        "Makefile" = {
          "indent_style" = "tab";
        };
      };
    };

    # home-manager configuration
    home = {
      sessionVariables = {
        CODE_HOME = "${cfg.codeHome}";
      };

      # developer-ey packages
      packages =
        (lib.optionals config.programs.fzf.enable [
          fzfGitCommits
          fzfRepo
        ])
        ++ [
          # bitwarden-cli

          # docker management
          #dive

          pkgs.diffsitter

          # audio/image/video processing
          #exiftool
          #ffmpeg
          #flac
          #ghostscript
          #image_optim
          #imagemagick
          #nodePackages.svgo

          # shell
          # shellcheck

          # html validate/format
          #tidyp

          # json, yaml, js, and more format
          #nodePackages.prettier

          # process mgmt
          # glances
          #gotop
          # nodePackages.nodemon

          # yubikey
          # yubikey-agent
          # yubikey-manager
          # yubikey-personalization

          # fun
          # ascii-image-converter
          # asciinema
          # nyancat
          # yt-dlp

          # spellingz
          #aspell
          #aspellDicts.en
          #aspellDicts.en-computers
          #aspellDicts.en-science
          #ispell
          #hunspell
          #hunspellDicts.en-us

          # nix-format-feltnerm

          # cloud
          # awscli

          # web servers
          # caddy
        ];
    };
  };
}
