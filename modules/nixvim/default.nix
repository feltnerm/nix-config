_:
{
  den.nixvim.x86_64-linux = {
    default = {};
    full = {};
  };

  den.schema.nixvim = {
    # default includes for all nixvims
    includes = [];

    # nxivm options
    options = {};

    # default nixvim configuration
    config = {};
  };

  # den.aspects.nixvim.base = {
  #   nixvim.imports = [ ./base.nix ];
  # };

  # den.aspects.nixvim.developer = {
  #   includes = [ den.aspects.nixvim.base ];
  #   nixvim.imports = [ ./developer.nix ];
  # };
}
