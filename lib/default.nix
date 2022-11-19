{inputs, ...}: let
  inherit (inputs) self nixpkgs unstable hardware nur home-manager darwin agenix;
  inherit (self) outputs;
  inherit (builtins) elemAt match any mapAttrs attrValues attrNames listToAttrs;
  inherit (nixpkgs.lib) nixosSystem filterAttrs genAttrs mapAttrs';
  inherit (home-manager.lib) homeManagerConfiguration;
in rec {
  getUsername = string: elemAt (match "(.*)@(.*)" string) 0;
  getHostname = string: elemAt (match "(.*)@(.*)" string) 1;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  forAllSystems = genAttrs systems;

  mkNixosSystem = {
    hostname,
    users,
    system ? "x86_64-linux",
    pkgs,
    systemConfig ? {},
  }: let
    userCfg = {
      inherit hostname;
    };

    systemUsers = map (mkUser {inherit pkgs userCfg;}) users;
    hostModule = ./..hosts + "/${hostname}" + /default.nix;
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

            #users.defaultUserShell = pkgs.zsh;
          }
          systemConfig
          hostModule
          # agenix.nixosModules
        ]
        ++ users;
    };

  mkDarwinSystem = {
    hostname,
    users,
    system ? "x86_64-darwin",
    pkgs,
    systemConfig ? {},
    ...
  }: let
    userCfg = {
      inherit hostname;
    };

    systemUsers = map (mkUser {inherit pkgs userCfg;}) users;
    hostModule = ./..hosts + "/${hostname}" + /default.nix;
  in
    darwin.lib.darwinSystem {
      inherit pkgs system;
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
            networking.useDHCP = false;

            #users.defaultUserShell = pkgs.zsh;
          }
          systemConfig
          hostModule
        ]
        ++ users;
    };

  # create a regular ol' user on a system
  mkUser = {
    pkgs,
    userConfig ? {},
    ...
  }: {
    username,
    initialPassword ? "spanky",
    uid,
    groups ? [],
  }: {
    users.users."${username}" = {
      isNormalUser = true;
      isSystemUser = false;

      name = username;
      inherit uid;
      initialPassword = "${initialPassword}";
      extraGroups = groups;

      shell = pkgs.zsh;

      createHome = true;
      home = "/home/${username}";
    };
  };

  # make a system user; for a daemon or something
  mkSystemUser = {
    username,
    groups ? [],
  }: {
    users.users."${username}" = {
      isNormalUser = false;
      isSystemUser = true;

      name = username;
      extraGroups = groups;
    };
  };

  # make a home-manager managed user
  mkHome = {
    username,
    hostname ? null,
    configuration ? outputs.nixosConfigurations,
    pkgs ? "${configuration}"."${hostname}".pkgs,
    colorscheme ? null,
    wallpaper ? null,
    features ? [],
    # features are imported
    userConfig ? {},
  }: let
    userModule = ./../home + "/${username}" + /default.nix;
  in
    homeManagerConfiguration {
      inherit pkgs;
      # additional arguments to all modules:
      extraSpecialArgs = {
        inherit inputs outputs hostname username colorscheme wallpaper features;
      };
      modules = [
        ../modules/common
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
