{inputs, ...}: let
  inherit (inputs) self nixpkgs home-manager darwin;
  inherit (self) outputs;
  inherit (builtins) elemAt match;
  inherit (nixpkgs.lib) nixosSystem genAttrs;
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
    defaultShell ? "bashInteractive",
    system ? "x86_64-linux",
    systemConfig ? {},
  }: let
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
    system ? "x86_64-darwin",
    systemConfig ? {},
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

  nixosUserFactory = {pkgs, ...}: {
    username,
    uid ? 1000,
    isSudo ? false,
    initialPassword ? "spanky",
    shell ? "bashInteractive",
  }: let
    groups =
      if isSudo
      then [
        "wheel"
        "audio"
        "disk"
        "input"
        "network"
        "networkmanager"
        "systemd-journal"
        "video"
      ]
      else [];

    userShell = pkgs."${shell}";

    isNormalUser = true;
    isSystemUser = false;
  in {
    users.users."${username}" = {
      inherit uid isNormalUser isSystemUser;
      shell = userShell;
      initialPassword = "${initialPassword}";
      extraGroups = groups;
      createHome = true;
      home = "/home/${username}";
    };
  };

  darwinUserFactory = {pkgs, ...}: {
    username,
    shell ? "bashInteractive",
    uid ? 1000,
    isSudo ? false,
  }: let
    groups =
      if isSudo
      then ["admin"]
      else [];
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

  # make a home-manager managed user
  mkHome = {
    username,
    hostname,
    pkgs,
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
