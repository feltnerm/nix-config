{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.tmux;

  alacrittyEnabled = config.programs.alacritty.enable;

  # FIXME broken on macOS: https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95
  # equivalent to `set -g default-terminal "tmux-256color"`
  #terminal = "tmux-256color";
  terminal = "screen-256color";

  # equivalent to `set -ag terminal-overrides ",alacritty:RGB"`
  terminalOverrides = [
    (
      if alacrittyEnabled
      then "alacritty:RGB"
      else null
    )
    "xterm-256color:RGB"
  ];

  # default-shell
  defaultShell = null;

  shell =
    if config.programs.zsh.enable
    then "${pkgs.zsh}/bin/zsh"
    else defaultShell;

  # https://github.com/alacritty/alacritty/issues/109
  extraConfig = ''
    set-option -ag terminal-overrides ',${builtins.concatStringsSep "," terminalOverrides}'
  '';
in {
  options.feltnerm.programs.tmux = {
    enable = lib.mkOption {
      description = "Enable tmux.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      inherit shell terminal extraConfig;

      enable = true;
      prefix = "C-a";
      keyMode = "vi";
      clock24 = true;
      escapeTime = 10;
      newSession = false; # Automatically spawn a session if trying to attach and none are running.
      secureSocket = true; # More secure tmux socket; removed at logout.
      plugins = with pkgs.tmuxPlugins; [
        jump
        net-speed
        prefix-highlight
        sysstat
        tmux-fzf
        yank
      ];
    };
  };
}
