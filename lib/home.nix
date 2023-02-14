{inputs, ...}: let
  inherit (inputs) self home-manager;
  inherit (self) outputs;
  inherit (home-manager.lib) homeManagerConfiguration;
in {
  # make a home-manager managed user
  mkHome = {
    # The user's name. Required.
    username,
    #
    pkgs,
    # The user-specific module.
    userModule ? ./../home + "/${username}" + /default.nix,
    # Any extra modules to load.
    extraModules ? [],
    # Any extra config for this user.
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
