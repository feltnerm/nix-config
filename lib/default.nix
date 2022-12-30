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
    pkgs,
    defaultShell ? "bash",
    system ? "x86_64-linux",
    systemConfig ? {},
  }: let
    userCfg = {
      inherit hostname;
    };

    hostModule = ./../hosts + "/${hostname}" + /default.nix;
    mkNixosUser = nixosUserFactory pkgs;
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

  mkDarwinSystem = {
    hostname,
    users,
    pkgs,
    defaultShell ? "bash",
    system ? "x86_64-darwin",
    systemConfig ? {},
    ...
  }: let
    userCfg = {
      inherit hostname;
    };

    hostModule = ./../hosts + "/${hostname}" + /default.nix;
    mkDarwinUser = darwinUserFactory pkgs;
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

            users.defaultUserShell = pkgs."${defaultShell}";
          }
          systemConfig
          hostModule
        ]
        ++ (map mkDarwinUser users);
    };

  nixosUserFactory = {pkgs, ...}: {
    username,
    uid ? 1000,
    isSudo ? false,
    initialPassword ? "spanky",
    shell ? "bash",
  }: let
    groups =
      if isSudo
      then [
        "wheel"
        "disk"
        "audio"
        "video"
        "input"
        "systemd-journal"
        "networkmanager"
        "network"
      ]
      else [];
  in
    mkUser {
      inherit username initialPassword uid groups;
      shell = pkgs."${shell}";
    };

  darwinUserFactory = {pkgs, ...}: {
    username,
    initialPassword ? "spanky",
    shell ? "bash",
    isSudo ? false,
    uid ? 1000,
  }: let
    groups =
      if isSudo
      then []
      else [];
  in
    mkUser {
      inherit username initialPassword uid groups;
      shell = pkgs."${shell}";
    };

  mkUser = {
    username,
    uid,
    shell,
    createHome ? true,
    groups ? [],
    home ? "/home/${username}",
    initialPassword ? "spanky",
    isNormalUser ? true,
    isSystemUser ? false,
  }: let
    user = {
      inherit uid createHome home isNormalUser isSystemUser shell;
      name = username;
      initialPassword = "${initialPassword}";
      extraGroups = groups;
    };
  in {
    users.users."${username}" = user;
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
