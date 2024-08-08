{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.profiles.developer;

  # quick search for a repo and `cd` to its directory
  fzfReposZshExtra = ''
    function c() {
      cd -- $(fzf-repo "$1")
    }
  '';

  # grep git commits
  fzfGitCommits = pkgs.writeShellApplication {
    name = "fzf-git-commits";
    runtimeInputs = [pkgs.fzf pkgs.git pkgs.diff-so-fancy];
    text = "git log --oneline | fzf --multi --preview 'git show {+1} | diff-so-fancy --color'";
  };

  # search for my repos
  fzfRepo = pkgs.writeShellApplication {
    name = "fzf-repo";
    runtimeInputs = [pkgs.fzf pkgs.eza];
    text = builtins.readFile ./fzf-repo.sh;
  };
in {
  options.feltnerm.profiles.developer.code = {
    enable = lib.mkOption {
      description = "Enable the $CODE directory.";
      default = true;
    };

    codeDir = lib.mkOption {
      description = "Set the the directory";
      default = "code";
      # default = "${config.home.homeDirectory}/code";
    };
  };

  config = lib.mkIf cfg.enable {
    feltnerm = {
      # inherit the minimal profile
      profiles.minimal.enable = lib.mkForce true;

      programs = {
        git.enable = true;
        gpg.enable = true;
        neovim = {
          developer.enable = true;
        };
      };
    };

    programs = {
      zsh.initExtra = fzfReposZshExtra;
    };

    # home-manager configuration
    home = {
      sessionVariables = lib.mkIf cfg.code.enable {
        CODE_HOME = "${config.home.homeDirectory}/cfg.code.codeDir";
      };

      file.".editorconfig" = {
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

      # developer-ey packages
      packages = with pkgs; [
        bitwarden-cli

        # docker management
        dive

        diffsitter

        # audio/image/video processing
        exiftool
        ffmpeg
        flac
        ghostscript
        image_optim
        imagemagick
        nodePackages.svgo

        # browsers
        lynx
        # TODO surfraw configuration
        surfraw

        # file browsers
        mc #midnight commander
        ncdu_1 # FIXME once zig is stable
        ranger
        nnn

        # nix
        niv

        # shell
        shellcheck

        # html validate/format
        tidyp

        # json, yaml, js, and more format
        nodePackages.prettier

        # process mgmt
        glances
        #gotop
        nodePackages.nodemon

        # yubikey
        yubikey-agent
        yubikey-manager
        yubikey-personalization

        # fun
        ascii-image-converter
        asciinema
        nyancat
        yt-dlp

        # spellingz
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science
        ispell
        hunspell
        hunspellDicts.en-us

        fzfGitCommits
        fzfRepo

        feltnerm.nix-format-feltnerm

        # cloud
        # awscli

        # web servers
        # caddy
      ];
    };
  };
}
