{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.feltnerm.programs.hm;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options = {
    feltnerm.programs.hm.enable = lib.mkEnableOption "home-manager";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
