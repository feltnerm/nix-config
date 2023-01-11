{inputs, ...}: let
  inherit (inputs) self;
  inherit (self) outputs;
  inherit (home-manager.lib) homeManagerConfiguration;
in rec {
  # make a home-manager managed user
  mkHome = {
    username,
    pkgs,
    userModule ? ./../home + "/${username}" + /default.nix,
    userConfig ? {},
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
