{
  pkgs,
  config,
  ...
}: let
  inherit (config.feltnerm.config.code) codeDir;

  # TODO organize these helpers
  # TODO
  #fzfTmuxSesions = pkgs.writeShellApplication {
  #}

  fzfRepo = pkgs.writeShellApplication {
    name = "fzf-repo";
    text = ''
      function _fzf-repo() {
        local query
        local repo
        local path

        local previewCommand
        previewCommand="exa --icons --git-ignore --group-directories-first --git -1"

        query="''${1:-}"
        repo=$(cd "${codeDir}" && tree -L 1 -dfiC -- * | fzf --query "$query" --scheme=path --filepath-word --ansi --header code --no-info --preview "$previewCommand {+}" --preview-label files)
        if [[ -n "$repo" ]]
        then
          path="${codeDir}/$repo"
          echo -e "$path"
        fi
      }

      _fzf-repo "$@"
    '';
  };
in {
  imports = [./neovim];

  config = {
    home.shellAliases = {
      cat = "bat";
    };

    feltnerm = {
      config.xdg.enable = true;
      programs = {
        readline.enable = true;
        ssh.enable = true;
        tmux.enable = true;
        zsh.enable = true;
      };
    };

    programs = {
      bat.enable = true;
      direnv = {
        enable = true;
        nix-direnv = {
          enable = true;
        };
      };
      dircolors = {
        enable = true;
      };
      exa = {
        enable = true;
        enableAliases = true;
      };
      fzf = {
        enable = true;
        tmux = {
          #enableShellIntegration = true;
        };
      };
      htop.enable = true;
      info.enable = true;
      jq.enable = true;

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
      zsh.initExtra = ''
        function c() {
          cd -- $(fzf-repo "$1")
        }
      '';
    };
    home.packages = with pkgs; [
      # docker management
      dive

      # audio/image/video processing
      exiftool
      ffmpeg
      flac
      ghostscript
      imagemagick

      # browsers
      lynx
      # TODO surfraw configuration
      surfraw

      # file browsers
      mc #midnight commander
      ncdu
      ranger
      nnn

      # nix
      niv

      # shell
      shellcheck

      # fun
      asciinema
      nyancat
      youtube-dl

      # spellingz
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      ispell
      hunspell
      hunspellDicts.en-us

      fzfRepo

      # cloud
      # awscli

      # web servers
      # caddy
    ];
  };
}
