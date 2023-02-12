{inputs, ...}: let
  inherit (inputs) self nixpkgs;
  inherit (self) outputs;
  inherit (nixpkgs.lib) nixosSystem;

  user = import ./user.nix {inherit inputs;};
in {
  mkNixosSystem = {
    # The system's hostname. Required.
    hostname,
    # A list of users for this system. Required.
    users,
    #
    pkgs,
    # A list of users to home-manager for this system.
    homeManagerUsers ? [],
    # The host-specific nix module.
    hostModule ? ./../hosts + "/${hostname}" + /default.nix,
    # Any extra modules to load.
    extraModules ? [],
    # The default shell of the system.
    defaultShell ? "bashInteractive",
    # The system type.
    system ? "x86_64-linux",
    # Any extra config for this system.
    systemConfig ? {},
    ...
  }: let
    mkNixosUser = user.nixosUserFactory pkgs;
    baseModule = {
      # set hostname of this machine
      networking.hostName = hostname;

      # by default, disable any non-enabled networking interface
      networking.useDHCP = false;

      users.defaultUserShell = pkgs."${defaultShell}";
    };
  in
    nixosSystem {
      inherit pkgs system;
      specialArgs = {
        inherit inputs outputs hostname users systemConfig;
      };
      modules =
        [
          ../modules/common
          ../modules/nixos
          baseModule
        ]
        ++ extraModules
        ++ [
          systemConfig
          hostModule
          # agenix.nixosModules
        ]
        ++ (map mkNixosUser users);
    };
}
