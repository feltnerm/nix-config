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
        set-option -g default-terminal "tmux-256color"
        set-option -sa terminal-overrides ",alacritty:Tc"

        # Base17 Gruvbox dark, soft
        # Scheme author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
        # Template author: Tinted Theming: (https://github.com/tinted-theming)

        # default statusbar colors
        set-option -g status-style "fg=#bdae93,bg=#3c3836"

        # default window title colors
        set-window-option -g window-status-style "fg=#bdae93,bg=default"

        # active window title colors
        set-window-option -g window-status-current-style "fg=#fabd2f,bg=default"

        # pane border
        set-option -g pane-border-style "fg=#3c3836"
        set-option -g pane-active-border-style "fg=#504945"

        # message text
        set-option -g message-style "fg=#d5c4a1,bg=#3c3836"

        # pane number display
        set-option -g display-panes-active-colour "#b8bb26"
        set-option -g display-panes-colour "#fabd2f"

        # clock
        set-window-option -g clock-mode-colour "#b8bb26"

        # copy mode highligh
        set-window-option -g mode-style "fg=#bdae93,bg=#504945"

        # bell
        set-window-option -g window-status-bell-style "fg=#3c3836,bg=#fb4934"

        # This tmux statusbar config was created by tmuxline.vim
        # on Mon, 16 Jan 2023

        set -g status-justify "left"
        set -g status "on"
        set -g status-left-style "none"
        set -g message-command-style "fg=#bdae93,bg=#504945"
        set -g status-right-style "none"
        set -g pane-active-border-style "fg=#bdae93"
        set -g status-style "none,bg=#3c3836"
        set -g message-style "fg=#bdae93,bg=#504945"
        set -g pane-border-style "fg=#504945"
        set -g status-right-length "100"
        set -g status-left-length "100"
        setw -g window-status-activity-style "none"
        setw -g window-status-separator ""
        setw -g window-status-style "none,fg=#bdae93,bg=#3c3836"
        set -g status-left "#[fg=#3c3836,bg=#bdae93] #S #[fg=#bdae93,bg=#3c3836,nobold,nounderscore,noitalics]"
        set -g status-right "#[fg=#504945,bg=#3c3836,nobold,nounderscore,noitalics]#[fg=#bdae93,bg=#504945] %Y-%m-%d  %H:%M #[fg=#bdae93,bg=#504945,nobold,nounderscore,noitalics]#[fg=#3c3836,bg=#bdae93] #h "
        setw -g window-status-format "#[fg=#bdae93,bg=#3c3836] #I #[fg=#bdae93,bg=#3c3836] #W "
        setw -g window-status-current-format "#[fg=#3c3836,bg=#504945,nobold,nounderscore,noitalics]#[fg=#bdae93,bg=#504945] #I #[fg=#bdae93,bg=#504945] #W #[fg=#504945,bg=#3c3836,nobold,nounderscore,noitalics]"


      '';
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
