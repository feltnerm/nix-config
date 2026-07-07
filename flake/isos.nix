{ den, inputs, ... }:
{
  # Expose convenience packages for building ISOs
  perSystem =
    { system, ... }:
    {
      packages =
        let
          nixosSystem = inputs.nixpkgs.lib.nixosSystem;
        in
        {
          # Live ISOs
          iso-livecd =
            (nixosSystem {
              inherit system;
              specialArgs = { inherit inputs den; };
              modules = [
                (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
                ../modules/hosts/livecd/host.nix
                ../modules/nixos/iso-base.nix
                ../modules/nixos/live-iso.nix
              ];
            }).config.system.build.isoImage;

          iso-livecd-gui =
            (nixosSystem {
              inherit system;
              specialArgs = { inherit inputs den; };
              modules = [
                (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
                ../modules/hosts/livecd-gui/host.nix
                ../modules/nixos/iso-base.nix
                ../modules/nixos/live-iso.nix
              ];
            }).config.system.build.isoImage;

          # Installer ISOs (interactive, small/light, offline-capable via closure)
          iso-codemonkey-installer =
            (nixosSystem {
              inherit system;
              specialArgs = { inherit inputs den; };
              modules = [
                ../modules/nixos/installer.nix
                {
                  networking.hostName = "codemonkey-installer";
                }
              ];
            }).config.system.build.isoImage;

          iso-markbook-installer =
            (nixosSystem {
              inherit system;
              specialArgs = { inherit inputs den; };
              modules = [
                ../modules/nixos/installer.nix
                {
                  networking.hostName = "markbook-installer";
                }
              ];
            }).config.system.build.isoImage;
        };
    };
}
