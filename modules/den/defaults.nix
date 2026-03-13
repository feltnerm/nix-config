{
  den,
  inputs,
  lib,
  ...
}:
let
  specialArgs = { inherit inputs; };
in
{
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default.includes = [
    den.provides.hostname
  ];

  den.default.user = {
    isNormalUser = lib.mkDefault true;
    createHome = lib.mkDefault true;
  };

  den.schema.host =
    { config, ... }:
    {
      hjem.enable = lib.mkDefault false;
      "nix-maid".enable = lib.mkDefault false;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      instantiate = lib.mkDefault (
        if config.class == "darwin" then
          (
            { modules }:
            inputs.darwin.lib.darwinSystem {
              inherit modules;
              inherit specialArgs;
            }
          )
        else
          (
            { modules }:
            inputs.nixpkgs.lib.nixosSystem {
              inherit modules;
              inherit specialArgs;
            }
          )
      );
    };
}
