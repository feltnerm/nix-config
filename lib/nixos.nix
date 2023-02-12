{inputs, ...}: let
  inherit (inputs) self nixpkgs;
  inherit (self) outputs;
  inherit (nixpkgs.lib) nixosSystem;

  user = import ./user.nix {inherit inputs;};
in {
  mkNixosSystem = {
    hostname,
    users,
    pkgs,
    hostModule ? ./../hosts + "/${hostname}" + /default.nix,
    extraModules ? [],
    defaultShell ? "bashInteractive",
    system ? "x86_64-linux",
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
