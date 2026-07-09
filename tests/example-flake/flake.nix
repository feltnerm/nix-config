{
  description = "Integration test for feltnerm/nix-config (minimal)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    den.url = "github:vic/den";
    # Use the repository root as the input under local development
    feltnerm-config.url = "path:../..";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    {
      # Minimal NixOS configuration to validate downstream usage
      nixosConfigurations.test-minimal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {
          inherit inputs;
        };
        modules = [
          inputs.den.flakeModule
          inputs.feltnerm-config.nixosModules.default
          {
            # Minimal system usage: include a tiny host module
            imports = [ ./hosts/test-nixos ];
          }
        ];
      };

    };
}
