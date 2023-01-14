{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.tmux;

  tmuxn = pkgs.writeShellApplication {
    name = "tmuxn";
    text = ''
      function _tmuxn() {
        local sessionName
        sessionName="''${1:-}"
        if [[ -z "$sessionName" ]]
        then
          local currentDir
          local baseDir
          currentDir=$(pwd)
          baseDir=$(basename "$currentDir")
          tmux new-session -s "$baseDir"
        else
          tmux new-session -s "$sessionName"
        fi
      }
      _tmuxn "$@"
    '';
  };

  tmuxa = pkgs.writeShellApplication {
    name = "tmuxa";
    text = ''
      # attach to a tmux session in the current directory
      function _tmuxa() {
        local sessionName
        sessionName="''${1:=}"
        if [[ -z "$sessionName" ]]
        then
          local currentDir
          local baseDir
          currentDir=$(pwd)
          baseDir=$(basename "$currentDir")
          tmux attach-session -t "$baseDir"
        else
          tmux attach-session -t "$sessionName"
        fi
      }
      _tmuxa "$@"
    '';
  };

  inherit (config.feltnerm.config.code) codeDir;
  tmuxcn = pkgs.writeShellApplication {
    name = "tmuxcn";
    text = ''
      function startSession() {
        cd "$1" && tmuxn "$2"
      }

      function _tmuxcn() {
        local repoPath
        repoPath="''${1:?Must define a repo}"
        #if [[ -z "$repoShortPath" ]]
        #then
        #  exit 1
        #else
        #fi

        local pathToCheck
        pathToCheck="${codeDir}/$repoPath"
        [ -d "$pathToCheck" ] && startSession "$pathToCheck" "$repoPath"

        pathToCheck="${codeDir}/feltnerm/$repoPath"
        [ -d "$pathToCheck" ] && startSession "$pathToCheck" "feltnerm/$repoPath"

        pathToCheck="${codeDir}/feltnerm/scratch$repoPath"
        [ -d "$pathToCheck" ] && startSession "$pathToCheck" "scratch/$repoPath"

        pathToCheck="${codeDir}/scratch/$repoPath"
        [ -d "$pathToCheck" ] && startSession "$pathToCheck" "scratch/$repoPath"

        echo -e "No repo found"
      }
      _tmuxcn "$@"
    '';
  };

  tmuxca = pkgs.writeShellApplication {
    name = "tmuxca";
    text = ''
      function attachSession() {
        cd "$1" && tmuxa "$2"
      }

      function _tmuxca() {
        local repoPath
        repoPath="''${1:?Must define a repo}"
        #if [[ -z "$repoShortPath" ]]
        #then
        #  exit 1
        #else
        #fi

        local pathToCheck
        pathToCheck="${codeDir}/$repoPath"
        [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "$repoPath"

        pathToCheck="${codeDir}/feltnerm/$repoPath"
        [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "feltnerm/$repoPath"

        pathToCheck="${codeDir}/feltnerm/scratch$repoPath"
        [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "scratch/$repoPath"

        pathToCheck="${codeDir}/scratch/$repoPath"
        [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "scratch/$repoPath"

        echo -e "No repo found"
      }
      _tmuxca "$@"
    '';
  };
in {
  options.feltnerm.programs.tmux = {
    enable = lib.mkOption {
      description = "Enable tmux.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-a";
      keyMode = "vi";
      clock24 = true;
      escapeTime = 10;
      newSession = true; # Automatically spawn a session if trying to attach and none are running.
      secureSocket = true; # More secure tmux socket; removed at logout.
      # TODO configure tmux plugins and extra config
      plugins = [];
      # extraConfig = "";
      extraConfig = ''
        set-option -g default-terminal "screen-256color"
        set-option -sa terminal-overrides ',screen:RGB
      '';
    };

    home.packages = lib.mkIf cfg.enable [
      tmuxn
      tmuxa
      (lib.mkIf config.feltnerm.config.code.enableCodeDir tmuxcn)
      (lib.mkIf config.feltnerm.config.code.enableCodeDir tmuxca)
    ];

    # programs.zsh.initExtra = lib.mkIf config.feltnerm.programs.zsh.enable (builtins.readFile ./tmux.zsh);
  };
}
