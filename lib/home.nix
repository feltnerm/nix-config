{ inputs, ... }:
let
  inherit (inputs) self home-manager;
  inherit (self) outputs;
  inherit (home-manager.lib) homeManagerConfiguration;
in
{
  # make a home-manager managed user
  mkHome =
    {
      # The user's name. Required.
      username,
      #
      pkgs,
      # Any extra modules to load.
      extraModules ? [ ],
      # The user-specific module based on the username, but can be overridden.
      userModule ? ./../conf/home + "/${username}" + /default.nix,
      # Any extra config for this user.
      userConfig ? { },
      ...
    }:
    let
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
          # ../modules/common
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
