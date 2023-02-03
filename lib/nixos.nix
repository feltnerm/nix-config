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
    defaultShell ? "bashInteractive",
    system ? "x86_64-linux",
    systemConfig ? {},
    ...
  }: let
    hostModule = ./../hosts + "/${hostname}" + /default.nix;
    mkNixosUser = user.nixosUserFactory pkgs;
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
          {
            # set hostname of this machine
            networking.hostName = hostname;

            # by default, disable any non-enabled networking interface
            networking.useDHCP = false;

            users.defaultUserShell = pkgs."${defaultShell}";
          }
          systemConfig
          hostModule
          # agenix.nixosModules
        ]
        ++ (map mkNixosUser users);
    };
}
