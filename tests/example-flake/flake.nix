{
  description = "Integration test for feltnerm/nix-config (minimal)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
    }:
    {
      # Minimal NixOS configuration to validate downstream usage
      nixosConfigurations.test-minimal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          feltnerm-config.nixosModules.default
          {
            # Minimal system usage: include a tiny host module
            imports = [ ./hosts/test-nixos ];
          }
        ];
      };

      # Provide a simple check target for `nix flake check`
      checks.x86_64-linux.example-build = self.nixosConfigurations.test-minimal.config.system.build.toplevel;
    };
}
