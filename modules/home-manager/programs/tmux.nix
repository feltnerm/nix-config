{
  pkgs,
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
      # TODO detect based on config values
      defaultShell = "\${pkgs.zsh}/bin/zsh";
      defaultTerminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        jump
        net-speed
        prefix-highlight
        sysstat
        tmux-fzf
        yank
      ];
      # extraConfig = "";
      extraConfig = ''
        set-option -g default-terminal "screen-256color"
        set-option -sa terminal-overrides ',alacritty:RGB
      '';
    };
  };
}
