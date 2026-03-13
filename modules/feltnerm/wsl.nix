_: {
  config.den.aspects.features.provides.wsl = {
    nixos = {
      wsl.enable = true;
      programs.nix-ld.enable = true;
    };
  };
}
