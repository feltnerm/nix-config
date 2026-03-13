{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.apple-macbook-pro-11-1
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./disko.nix
  ];

  config = {
    networking.hostName = "markbook";
  };
}
