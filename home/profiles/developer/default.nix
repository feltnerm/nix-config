{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.profiles.developer;

  editorConfig = builtins.readFile ./editorconfig;

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
  options.feltnerm.profiles.developer = {
    enable = lib.mkEnableOption "developer";
    codeDir = lib.mkOption {
      description = "Directory in $HOME for code. Also set as $CODE_HOME";
      default = "code";
    };
  };

  config = lib.mkIf cfg.enable {
    feltnerm = {
      profiles.minimal.enable = lib.mkForce true;

      nix.enableTools = true;
      git.enable = lib.mkDefault true;
      gpg.enable = lib.mkDefault true;
      neovim = {
        enable = lib.mkDefault true;
        developer.enable = lib.mkDefault true;
      };
    };

    programs = {
      zsh.initExtra = fzfReposZshExtra;
    };

    home = {
      sessionVariables = {
        CODE_HOME = "${config.home.homeDirectory}/${cfg.codeDir}";
      };

      # editorconfig
      file.".editorconfig" = {
        text = editorConfig;
      };

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

        # feltnerm.nix-format-feltnerm

        # cloud
        # awscli

        # web servers
        # caddy
      ];
    };
  };
}
