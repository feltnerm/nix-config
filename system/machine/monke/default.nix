{
  self,
  config,
  hostModules,
  hostname,
  ...
}: let
  machineModules = "${self}/system/machine/${hostname}/modules";
in {
  imports = [
    "${hostModules}"
    "${machineModules}"
  ];
  config = {
    feltnerm = {
      environment.enable = true;
      documentation.enable = true;
      fonts.enable = true;

      hardware = {
        audio.enable = true;
        bluetooth.enable = true;
        cpu = {
          enableMicrocode = true;
          vendor = "intel";
        };
        ssd.enable = true;
      };

      locale.enable = true;

      networking = {
        enable = true;
        interfaces = ["wlp2s0"];
      };

      programs = {
        enable = true;
        gnupg.enable = true;
        hm.enable = true;
        xdg-portal.enable = true;
      };

      security = {
        enable = true;
      };

      services = {
        greetd.enable = true;
        hyprland.enable = true;
        openssh.enable = true;
        # polkit.enable = true;
      };

      users = {
        enable = true;
      };

      virtualization = {
        enable = false; # TODO
      };
    };
  };
}
