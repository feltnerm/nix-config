{pkgs}:
{
  modules = import ./modules/nixos;
  homeManagerModules = import ./modules/home-manager;
  darwinModules = import ./modules/darwin;
}
# Import packages to top-level
// (import ./pkgs {inherit pkgs;})
