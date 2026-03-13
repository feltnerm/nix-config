_: {
  config.den.aspects.features.provides.vm-base = {
    nixos.imports = [ ../../nixos/vm-base.nix ];
  };

  config.den.aspects.features.provides.live-iso = {
    nixos.imports = [ ../../nixos/live-iso.nix ];
  };

  config.den.aspects.features.provides.wsl-base = {
    nixos.imports = [ ../../nixos/wsl-base.nix ];
  };
}
