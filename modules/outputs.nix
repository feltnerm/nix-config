{ lib, ... }:
{
  options.flake.den = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.unspecified);
    default = { };
    description = ''
      Den-managed system configurations, indexed first by output type
      (nixosConfigurations, homeConfigurations, …) and then by name.
    '';
  };
}
