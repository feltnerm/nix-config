{
  config,
  ...
}:
{
  imports = [
    ./darwin.nix
    ./den.nix
    ./devshells.nix
    ./flake-modules.nix
    ./home.nix
    ./isos.nix
    ./nixos.nix
    ./nixvim.nix
    ./overlays.nix
    ./pkgs.nix
    ./topology.nix
    ./treefmt.nix
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
