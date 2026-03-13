{
  description = "Integration test for feltnerm/nix-config (minimal)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    den.url = "github:vic/den";
    # Use the repository root as the input under local development
    feltnerm-config.url = "path:../..";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      feltnerm-config,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      # Minimal NixOS configuration to validate downstream usage
      nixosConfigurations.test-minimal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {
          inherit inputs;
        };
        modules = [
          inputs.den.flakeModule
          feltnerm-config.nixosModules.default
          {
            # Minimal system usage: include a tiny host module
            imports = [ ./hosts/test-nixos ];
          }
        ];
      };

      # Provide a simple check target for `nix flake check`
      checks.${system} = {
        example-build = self.nixosConfigurations.test-minimal.config.system.build.toplevel;
        example-home = feltnerm-config.homeConfigurations."mark-${system}".activationPackage;
        example-devshell = feltnerm-config.devShells.${system}.default;
        example-package = feltnerm-config.packages.${system}.greet;
      };
    };
}
