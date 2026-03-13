{ den, inputs, ... }:
{
  den.aspects.mark = {
    homeManager.imports = [
      ./mark/home.nix
    ];
    includes = [
      den.provides.define-user
      den.provides.primary-user
      den.aspects.features._.developer
      den.aspects.features._.home-cli-minimal
      (den.provides.user-shell "zsh")
    ];
  };
}
