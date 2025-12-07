{ inputs, ... }:
{
  config = {
    flake = {
      # Expose convenience packages for building ISOs
      perSystem =
        { pkgs, system, ... }:
        {
          packages = {
            # Live ISOs
            iso-codemonkey-live = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../configs/nixos/codemonkey
                ../modules/nixos/iso-base.nix
                ../modules/nixos/live-iso.nix
              ];
              format = "iso";
            };

            iso-markbook-live = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../configs/nixos/markbook
                ../modules/nixos/iso-base.nix
                ../modules/nixos/live-iso.nix
              ];
              format = "iso";
            };

            iso-virtmark-gui-live = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../configs/nixos/virtmark-gui
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

            iso-virtmark-gui-installer = inputs.nixos-generators.nixosGenerate {
              inherit system;
              modules = [
                ../modules/nixos/installer.nix
                ../configs/nixos/virtmark-gui
              ];
              format = "install-iso";
            };

            # Build all common ISOs
            iso-all = pkgs.symlinkJoin {
              name = "iso-all";
              paths = [
                (inputs.nixos-generators.nixosGenerate {
                  inherit system;
                  modules = [
                    ../modules/nixos/installer.nix
                    ../configs/nixos/codemonkey
                  ];
                  format = "install-iso";
                })
                (inputs.nixos-generators.nixosGenerate {
                  inherit system;
                  modules = [
                    ../modules/nixos/installer.nix
                    ../configs/nixos/markbook
                  ];
                  format = "install-iso";
                })
                (inputs.nixos-generators.nixosGenerate {
                  inherit system;
                  modules = [
                    ../modules/nixos/installer.nix
                    ../configs/nixos/virtmark-gui
                  ];
                  format = "install-iso";
                })
                (inputs.nixos-generators.nixosGenerate {
                  inherit system;
                  modules = [
                    ../configs/nixos/codemonkey
                    ../modules/nixos/iso-base.nix
                    ../modules/nixos/live-iso.nix
                  ];
                  format = "iso";
                })
                (inputs.nixos-generators.nixosGenerate {
                  inherit system;
                  modules = [
                    ../configs/nixos/markbook
                    ../modules/nixos/iso-base.nix
                    ../modules/nixos/live-iso.nix
                  ];
                  format = "iso";
                })
                (inputs.nixos-generators.nixosGenerate {
                  inherit system;
                  modules = [
                    ../configs/nixos/virtmark-gui
                    ../modules/nixos/iso-base.nix
                    ../modules/nixos/live-iso.nix
                  ];
                  format = "iso";
                })
              ];
            };
          };
        };
    };
  };
}
