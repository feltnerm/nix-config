{inputs, ...}: let
  inherit (inputs) self home-manager nur;
  inherit (self) outputs;
  inherit (home-manager.lib) homeManagerConfiguration;
in {
  # make a home-manager managed user
  mkHome = {
    username,
    pkgs,
    userModule ? ./../home + "/${username}" + /default.nix,
    userConfig ? {},
    nurModule ? nur.nixosModules.nur,
    colorscheme ? null,
    wallpaper ? null,
    features ? [],
    ...
  }:
    homeManagerConfiguration {
      inherit pkgs;
      # additional arguments to all modules:
      extraSpecialArgs = {
        inherit inputs outputs username colorscheme wallpaper features;
      };
      modules = [
        ../modules/home-manager
        nurModule
        {
          home = {
            inherit username;
          };
        }
        userModule
        userConfig
      ];
    };
}
