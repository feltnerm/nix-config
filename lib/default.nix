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

    systemUsers = map mkNixosUser users;
    hostModule = ./../hosts + "/${hostname}" + /default.nix;
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
        ++ systemUsers;
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

    systemUsers = map mkDarwinUser users;
    hostModule = ./../hosts + "/${hostname}" + /default.nix;
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
        ++ systemUsers;
    };

  mkNixosUser = {
    username,
    uid ? 1000,
    isSudo ? false,
    initialPassword ? "spanky",
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
    mkUser {inherit username initialPassword uid groups;};

  mkDarwinUser = {
    username,
    initialPassword ? "spanky",
    isSudo ? false,
    uid ? 1000,
  }: let
    groups =
      if isSudo
      then []
      else [];
  in
    mkUser {inherit username initialPassword uid groups;};

  mkUser = {
    username,
    uid,
    createHome ? true,
    groups ? [],
    home ? "/home/${username}",
    initialPassword ? "spanky",
    isNormalUser ? true,
    isSystemUser ? false,
  }: let
    user = {
      inherit uid createHome home isNormalUser isSystemUser;
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
