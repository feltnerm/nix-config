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
      else ""
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
  trueColorFix = ''
    set-option -ag terminal-overrides ',${builtins.concatStringsSep "," terminalOverrides}'
  '';

  colorScheme = builtins.readFile ./base17.tmux.conf;

  tmuxn = pkgs.writeShellApplication {
    name = "tmuxn";
    runtimeInputs = [pkgs.tmux];
    text = builtins.readFile ./tmuxn.sh;
  };

  tmuxa = pkgs.writeShellApplication {
    name = "tmuxa";
    runtimeInputs = [pkgs.tmux];
    text = builtins.readFile ./tmuxa.sh;
  };

  tmuxcn = pkgs.writeShellApplication {
    name = "tmuxcn";
    runtimeInputs = [pkgs.tmux];
    text = builtins.readFile ./tmuxn-repo.sh;
  };

  tmuxca = pkgs.writeShellApplication {
    name = "tmuxca";
    runtimeInputs = [pkgs.tmux];
    text = builtins.readFile ./tmuxa-repo.sh;
  };

  # not sure if needed
  tmuxls = pkgs.writeShellApplication {
    name = "tmuxls";
    runtimeInputs = [pkgs.tmux pkgs.fzf];
    text = builtins.readFile ./tmuxls.sh;
  };

  tmuxls-switch = pkgs.writeShellApplication {
    name = "tmuxls-switch";
    runtimeInputs = [tmuxls tmuxa pkgs.tmux];
    text = builtins.readFile ./tmuxls-switch.sh;
  };

  extraConfig =
    if cfg.colors.enable
    then trueColorFix + colorScheme
    else "";
in {
  options.feltnerm.programs.tmux = {
    enable = lib.mkOption {
      description = "Enable tmux.";
      default = false;
    };

    enableShellIntegration = lib.mkOption {
      description = "Enable shell integration with aliases/functions.";
      default = true;
    };

    colors.enable = lib.mkOption {
      description = "Enable colors for tmux.";
      default = false;
    };

    plugins = lib.mkOption {
      description = "tmux plugins. empty list disables any plugins";
      default = with pkgs.tmuxPlugins; [
        jump
        net-speed
        prefix-highlight
        sysstat
        tmux-fzf
        yank
      ];
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
      inherit (cfg) plugins;
    };

    home.packages = lib.mkIf cfg.enableShellIntegration [
      tmuxa
      tmuxn
      tmuxls
      tmuxls-switch
      (lib.mkIf config.feltnerm.profiles.developer.code.enable tmuxcn)
      (lib.mkIf config.feltnerm.profiles.developer.code.enable tmuxca)
    ];

    programs.neovim.plugins = with pkgs.vimPlugins;
      lib.mkIf config.feltnerm.programs.neovim.enable [
        tmuxline-vim
      ];
  };
}
