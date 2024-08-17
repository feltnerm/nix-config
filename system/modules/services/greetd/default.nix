{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.feltnerm.services.greetd;
in {
  options.feltnerm.services.greetd = {
    enable = lib.mkEnableOption "greetd";
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
    };

    services.greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          user = username;
          # command = "$HOME/.wayland-session";
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd --remember ${pkgs.hyprland}/bin/hyprland";
        };
      };
    };
  };
}
