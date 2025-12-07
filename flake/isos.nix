{ inputs, ... }:
{
  config = {
    flake = {
      # Expose convenience packages for building ISOs
      perSystem =
        { system, ... }:
        {
          packages = {
            # Live ISOs
            iso-livecd = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../configs/nixos/livecd
                ../modules/nixos/iso-base.nix
                ../modules/nixos/live-iso.nix
              ];
              format = "iso";
            };

            iso-livecd-gui = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../configs/nixos/livecd-gui
                ../modules/nixos/iso-base.nix
                ../modules/nixos/live-iso.nix
              ];
              format = "iso";
            };

            # Installer ISOs (interactive, small/light, offline-capable via closure)
            iso-codemonkey-installer = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../modules/nixos/installer.nix
                ../configs/nixos/codemonkey
              ];
              format = "install-iso";
            };

            iso-markbook-installer = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../modules/nixos/installer.nix
                ../configs/nixos/markbook
              ];
              format = "install-iso";
            };
          };
        };
    };
  };
}
