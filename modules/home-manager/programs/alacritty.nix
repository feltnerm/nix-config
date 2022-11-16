{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.alacritty;
in {
  options.feltnerm.programs.alacritty = {
    enable = lib.mkOption {
      description = "Enable alacritty";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {};
    };

    home.packages = with pkgs; [
      alacritty
    ];
  };
}
