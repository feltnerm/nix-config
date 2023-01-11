{inputs, ...}: let
  inherit (inputs) self darwin;
  inherit (self) outputs;

  systemIdentifier = "x86_64-darwin";
in rec {
  mkDarwinSystem = {
    hostname,
    users,
    pkgs,
    system ? systemIdentifier,
    systemConfig ? {},
    ...
  }: let
    hostModule = ./../hosts + "/${hostname}" + /default.nix;
    mkDarwinUser = darwinUserFactory pkgs;
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
          {
            # set hostname of this machine
            networking.hostName = hostname;

            # by default, disable any non-enabled networking interface
            # networking.useDHCP = false;

            # TODO
            # networking.computername = hostname;
          }
          systemConfig
          hostModule
        ]
        ++ (map mkDarwinUser users);
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
