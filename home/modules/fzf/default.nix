{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.fzf;

  # TODO use fzf-tmux
  # TODO organize these helpers
  # can be sourced lazily at runtime, or sourced at shell load
  # livegrep in files
  fzfFiles = pkgs.writeShellApplication {
    name = "fzf-files";
    runtimeInputs = [pkgs.fzf pkgs.bat];
    text = builtins.readFile ./fzf-files.sh;
  };

  # quick search for files and open them in vim
  fzfFilesZshExtra = ''
    function f() {
      vim -- $(fzf-files "$1")
    }
  '';
in {
  options.feltnerm.fzf = {
    enable = lib.mkEnableOption "fzf";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      # TODO
      # tmux = {
      #   enableShellIntegration = true;
      # };
    };

    home = {
      packages = [
        pkgs.fzf

        fzfFiles
      ];
    };

    programs.zsh.initExtra = fzfFilesZshExtra;
  };
}
