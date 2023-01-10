{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.tmux;
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
      extraConfig = "";
    };

    programs.zsh.initExtra = lib.mkIf config.feltnerm.programs.zsh.enable ''
      # create a tmux session in the current directory
      function tmuxn() {
        if [[ -z "$1" ]]
        then
          tmux new-session -s $(basename $(pwd))
        else
          tmux new-session -s "$1"
        fi
      }

      # attach to a tmux session in the current directory
      function tmuxa() {
        if [[ -z "$1" ]]
        then
          tmux attach-session -t $(basename $(pwd))
        else
          tmux attach-session -t "$1"
        fi
      }
    '';
  };
}
