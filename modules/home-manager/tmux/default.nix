{
  pkgs,
  config,
  lib,
  ...
}:
let

  tmuxn = pkgs.writeShellApplication {
    name = "tmuxn";
    runtimeInputs = [ pkgs.tmux ];
    text = builtins.readFile ./tmuxn.sh;
  };

  tmuxa = pkgs.writeShellApplication {
    name = "tmuxa";
    runtimeInputs = [ pkgs.tmux ];
    text = builtins.readFile ./tmuxa.sh;
  };

  tmuxls = pkgs.writeShellApplication {
    name = "tmuxls";
    runtimeInputs = [
      pkgs.tmux
      pkgs.fzf
    ];
    text = builtins.readFile ./tmuxls.sh;
  };

  tmuxls-switch = pkgs.writeShellApplication {
    name = "tmuxls-switch";
    runtimeInputs = [
      tmuxls
      tmuxa
      pkgs.tmux
    ];
    text = builtins.readFile ./tmuxls-switch.sh;
  };

in
{
  programs.tmux = lib.mkIf config.programs.tmux.enable {
    prefix = lib.mkDefault "C-a";
    keyMode = lib.mkDefault "vi";
    clock24 = lib.mkDefault true;
    escapeTime = lib.mkDefault 10;
    newSession = lib.mkDefault false; # Automatically spawn a session if trying to attach and none are running.
    secureSocket = lib.mkDefault true; # More secure tmux socket; removed at logout.
    plugins = with pkgs.tmuxPlugins; [
      jump
      net-speed
      prefix-highlight
      sysstat
      tmux-fzf
      yank
    ];
  };

  home.packages = [
    tmuxa
    tmuxn
    tmuxls
    tmuxls-switch
  ];
}
