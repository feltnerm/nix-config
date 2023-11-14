{
  pkgs,
  lib,
  config,
  ...
}: let
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

  extraConfig = colorScheme;
in {
  config = {
    programs.tmux = {
      inherit extraConfig;
    };
    home.packages = lib.mkIf config.feltnerm.programs.tmux.enable [
      tmuxa
      tmuxn
      tmuxls
      (lib.mkIf config.feltnerm.config.code.enableCodeDir tmuxcn)
      (lib.mkIf config.feltnerm.config.code.enableCodeDir tmuxca)
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      tmuxline-vim
    ];

    # programs.zsh.initExtra = lib.mkIf config.feltnerm.programs.zsh.enable (builtins.readFile ./tmux.zsh);
  };
}
