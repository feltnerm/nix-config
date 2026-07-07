{
  config,
  ...
}:
{
  imports = [
    ../modules/hosts

    ./den.nix

    ../modules/defaults.nix
    ../modules/home
    ../modules/outputs.nix
    ../modules/homes.nix

    ../modules/hosts/codemonkey
    ../modules/hosts/markbook
    ../modules/hosts/virtmark
    ../modules/hosts/virtmark-gui
    ../modules/hosts/livecd
    ../modules/hosts/livecd-gui
    ../modules/hosts/reddevil

    ../modules/feltnerm

    ./darwin.nix
    ./flake-modules.nix
    ./home.nix
    ./overlays.nix
    ./nixos.nix
    ./pkgs.nix
    ./topology.nix
    ./treefmt.nix
    ./isos.nix
  ];

  config = {
    flake = {
      homeConfigurations = config.flake.den.homeConfigurations or { };
      darwinConfigurations = config.flake.den.darwinConfigurations or { };
      nixosConfigurations = config.flake.den.nixosConfigurations or { };
      devShells = config.flake.den.devShells or { };
    };
  };

}
