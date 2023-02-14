{inputs, ...}: let
  inherit (inputs) self darwin home-manager;
  inherit (self) outputs;

  systemIdentifier = "x86_64-darwin";
in rec {
  mkDarwinSystem = {
    # The system's hostname. Required.
    hostname,
    # A list of users for this system. Required.
    users,
    #
    pkgs,
    # The system type.
    system ? systemIdentifier,
    # The host-specific nix module.
    hostModule ? ./../conf/hosts + "/${hostname}" + /default.nix,
    # Any extra modules to load.
    extraModules ? [],
    # Any extra config for this system.
    systemConfig ? {},
    # Any users to configure with home-manager
    homeManagerUsers ? [],
    ...
  }: let
    baseModule = {
      # set hostname of this machine
      networking.hostName = hostname;

      # by default, disable any non-enabled networking interface
      # networking.useDHCP = false;

      # TODO
      # networking.computername = hostname;
    };

    mkDarwinUser = darwinUserFactory pkgs;
    userModules = map mkDarwinUser users;

    useHomeManager = builtins.length homeManagerUsers > 0;
    homeManagerModules =
      if useHomeManager
      then [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ]
      else [];

    homeManagerUserModules =
      if useHomeManager
      then
        builtins.map (
          homeManagerUser: let
            inherit (homeManagerUser) username;
            userConfig =
              if builtins.hasAttr "userConfig" homeManagerUser && builtins.isAttrs homeManagerUser.userConfig
              then homeManagerUser.userConfig
              else {};
            userModule =
              if builtins.hasAttr "userModule" homeManagerUser && builtins.isPath homeManagerUser.userModule
              then homeManagerUser.userModule
              else ./../conf/home + "/${username}" + /default.nix;
          in {
            home-manager.extraSpecialArgs = {
              inherit inputs outputs username;
            };
            # home-manager.users."${username}" = userConfig;
            home-manager.users."${username}" = {
              imports = [
                ../modules/home-manager
                userModule
              ];
              config = userConfig;
            };
          }
        )
        homeManagerUsers
      else [];
  in
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs outputs hostname users systemConfig;
      };
      modules =
        [
          ../modules/common
          ../modules/darwin
          baseModule
        ]
        ++ homeManagerModules
        ++ extraModules
        ++ [
          systemConfig
          hostModule
        ]
        ++ userModules
        ++ homeManagerUserModules;
    };

  darwinUserFactory = {pkgs, ...}: {
    username,
    shell ? "bashInteractive",
    uid ? 1000,
    ...
  }: let
    userShell = pkgs."${shell}";
  in {
    users.users."${username}" = {
      inherit uid;
      name = username;
      shell = userShell;
      createHome = true;
      home = "/Users/${username}";
    };
  };
}
