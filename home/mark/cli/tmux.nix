{
  pkgs,
  lib,
  config,
  ...
}: let
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
in {
  config = {
    programs.tmux = {
      extraConfig = ''
        set-option -g default-terminal "screen-256color"
        set-option -sa terminal-overrides ',screen:RGB
      '';
    };
    home.packages = lib.mkIf config.feltnerm.programs.tmux.enable [
      tmuxa
      tmuxn
      tmuxls
      (lib.mkIf config.feltnerm.config.code.enableCodeDir tmuxcn)
      (lib.mkIf config.feltnerm.config.code.enableCodeDir tmuxca)
    ];

    # programs.zsh.initExtra = lib.mkIf config.feltnerm.programs.zsh.enable (builtins.readFile ./tmux.zsh);
  };
}
