{
  config,
  lib,
  pkgs,
  ...
}:
let
  # TODO use fzf-tmux
  # TODO organize these helpers
  # can be sourced lazily at runtime, or sourced at shell load
  # livegrep in files
  fzfFiles = pkgs.writeShellApplication {
    name = "fzf-files";
    runtimeInputs = [
      pkgs.fzf
      pkgs.bat
    ];
    text = builtins.readFile ./fzf-files.sh;
  };

  # quick search for files and open
  fzfFilesZshExtra = ''
    function f() {
      $EDITOR -- $(fzf-files "$1")
    }
  '';
in
lib.mkIf config.programs.fzf.enable {
  home = {
    packages = [
      fzfFiles
    ];
  };

  programs.zsh.initExtra = lib.mkIf config.programs.zsh.enable fzfFilesZshExtra;
}
