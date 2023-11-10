{pkgs ? import <nixpkgs> {}, ...}: {
  modules = import ./modules/nixos;
  homeManagerModules = import ./modules/home-manager;
  darwinModules = import ./modules/darwin;

  packages = import ./packages {inherit pkgs;};
}

