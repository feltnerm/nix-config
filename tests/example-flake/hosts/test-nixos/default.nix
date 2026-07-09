{ inputs, pkgs, lib, ... }:
{
  # Minimal base system to ensure the config evaluates
  boot.isContainer = true;
  system.stateVersion = "24.05";

  nixpkgs.overlays = [ inputs.feltnerm-config.overlays.default ];

  # Exercise the repo overlay and package outputs through the host module.
  environment.systemPackages = [
    pkgs.greet
    inputs.feltnerm-config.packages.${pkgs.system}.chuckscii
  ];

  # Very basic network settings
  networking.hostName = lib.mkDefault "test-minimal";

  # Avoid building man cache in CI to stabilize builds
  documentation.man.cache.enable = false;
}
