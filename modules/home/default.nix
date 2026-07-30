_:
{
  den.homes.x86_64-linux = {
    mark = {};
  };

  # den.aspects.mark = {
  #   homeManager.imports = [
  #     ./mark/home.nix
  #   ];
  #   includes = [
  #     den.provides.define-user
  #     den.provides.primary-user
  #     den.aspects.features._.developer
  #     den.aspects.features._.home-cli-minimal
  #     (den.provides.user-shell "zsh")
  #   ];
  # };

  # Schema validation for home configurations
  den.schema.home = {
    # default includes for all homes
    includes = [];

    # home options
    options = {};

    # Default home configuration
    config = {};
  };
}
