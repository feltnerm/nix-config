{inputs, ...}: let
  inherit (inputs) self darwin;
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
    hostModule ? ./../hosts + "/${hostname}" + /default.nix,
    # Any extra modules to load.
    extraModules ? [],
    # Any extra config for this system.
    systemConfig ? {},
    ...
  }: let
    mkDarwinUser = darwinUserFactory pkgs;

    baseModule = {
      # set hostname of this machine
      networking.hostName = hostname;

      # by default, disable any non-enabled networking interface
      # networking.useDHCP = false;

      # TODO
      # networking.computername = hostname;
    };

    userModules = map mkDarwinUser users;
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
        ++ extraModules
        ++ [
          systemConfig
          hostModule
        ]
        ++ userModules;
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
