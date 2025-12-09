{ pkgs, lib, ... }:
{
  # Minimal base system to ensure the config evaluates
  boot.isContainer = true;
  system.stateVersion = "24.05";

  # Include at least one package to exercise overlays usage downstream
  environment.systemPackages = with pkgs; [ hello ];

  # Very basic network settings
  networking.hostName = lib.mkDefault "test-minimal";

  # Avoid building man cache in CI to stabilize builds
  documentation.man.generateCaches = false;
}
