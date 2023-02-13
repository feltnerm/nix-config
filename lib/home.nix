{inputs, ...}: let
  inherit (inputs) self home-manager;
  inherit (self) outputs;
  inherit (home-manager.lib) homeManagerConfiguration;
in {
  # make a home-manager managed user
  mkHome = {
    username,
    pkgs,
    userModule ? ./../home + "/${username}" + /default.nix,
    extraModules ? [],
    userConfig ? {},
    ...
  }: let
    baseModule = {
      home = {
        inherit username;
      };
    };
  in
    homeManagerConfiguration {
      inherit pkgs;
      # additional arguments to all modules:
      extraSpecialArgs = {
        inherit inputs outputs username;
      };
      modules =
        [
          ../modules/home-manager
          baseModule
        ]
        ++ extraModules
        ++ [
          userModule
          userConfig
        ];
    };
}
