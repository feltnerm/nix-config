{inputs, ...}: let
  darwin = import ./darwin.nix {inherit inputs;};
  home = import ./home.nix {inherit inputs;};
  nixos = import ./nixos.nix {inherit inputs;};
  user = import ./user.nix {inherit inputs;};
  utils = import ./utils.nix {inherit inputs;};
in {
  inherit darwin home nixos user utils;
}
