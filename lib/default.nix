{inputs, ...}: let
  inherit (inputs) self nixpkgs unstable hardware nur home-manager agenix;
  inherit (self) outputs;
  inherit (builtins) elemAt match any mapAttrs attrValues attrNames listToAttrs;
  inherit (nixpkgs.lib) nixosSystem filterAttrs genAttrs mapAttrs';
  inherit (home-manager.lib) homeManagerConfiguration;
in rec {
  # Applies a function to a attrset's names, while keeping the values
  mapAttrNames = f:
    mapAttrs' (name: value: {
      name = f name;
      inherit value;
    });

  has = element: any (x: x == element);

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

  mkSystem = {
    hostname,
    users,
    pkgs,
    # pkgs ? outputs.nixosConfigurations.${hostname}.pkgs
    systemConfig ? {},
  }: let
    # host_users = map (u: mkUser u) users;
    userCfg = {
      inherit hostname;
    };

    hostModule = ./../hosts + "/${hostname}" + /default.nix;
  in
    nixosSystem {
      inherit pkgs;
      # TODO make this modular, it should be
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs hostname users systemConfig;
      };
      # modules = attrValues (import ../modules/nixos)
      modules =
        [
          # import ../modules/nixos
          {
            #imports = [(import ../modules/nixos {inherit inputs;})] ++ (map (u: mkUser u) users);
            imports = [(import ../modules/nixos {inherit inputs;})];

            feltnerm = systemConfig;
            # TODO is this module needed?

            # set hostname of this machine
            networking.hostName = hostname;

            # by default, disable any non-enabled networking interface
            networking.useDHCP = false;

            #users.defaultUserShell = pkgs.zsh;
          }
        ]
        ++ map mkUser users
        ++ [hostModule];
      #++ [agenix.nixosModule];
    };

  # create a regular ol' user on a system
  mkUser = {
    username,
    initialPassword ? "spanky",
    uid,
    pkgs,
    groups ? [],
  }: {
    users.users."${username}" = {
      # inherit pkgs;
      isNormalUser = true;
      isSystemUser = false;

      name = username;
      inherit uid;
      initialPassword = "${initialPassword}";
      extraGroups = groups;

      #shell = pkgs.zsh;

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
    pkgs ? outputs.nixosConfigurations.${hostname}.pkgs,
    colorscheme ? null,
    wallpaper ? null,
    features ? [], # features are imported
    userConfig ? {},
  }: let
    userModule = ./../home + "/${username}" + /default.nix;
  in
    homeManagerConfiguration {
      # TODO does this set useGlobalPkgs and useUserPackages to true, essentially?
      inherit pkgs username;
      # TODO make this modular, it should be
      system = "x86_64-linux";

      homeDirectory = "/home/${username}";

      # additional arguments to all modules:
      extraSpecialArgs = {
        inherit inputs outputs hostname username colorscheme wallpaper features userConfig;
      };

      configuration = {
        feltnerm = userConfig;
      };

      # define modules to load:
      # modules = attrValues (import ../modules/home-manager)
      extraModules =
        [
          {
            imports = [
              (import ../modules/home-manager {inherit inputs;})
            ];
          }
        ]
        ++ [userModule];
    };

  # mkDeploys = nixosConfigs: homeConfigs:
  #   let
  #     nixosProfiles = mapAttrs mkNixosDeployProfile nixosConfigs;
  #     homeProfiles = mapAttrs mkHomeDeployProfile homeConfigs;
  #     hostnames = attrNames nixosProfiles;

  #     homesOn = hostname: filterAttrs (name: _: (getHostname name) == hostname) homeProfiles;
  #     systemOn = hostname: { system = nixosProfiles.${hostname}; };
  #     profilesOn = hostname: (systemOn hostname) // (mapAttrNames getUsername (homesOn hostname));
  #   in
  #   listToAttrs (map
  #     (hostname: {
  #       name = hostname;
  #       value = {
  #         inherit hostname;
  #         profiles = profilesOn hostname;
  #       };
  #     })
  #     hostnames);

  # mkNixosDeployProfile = _name: config: {
  #   user = "root";
  #   path = activate "nixos" config;
  # };

  # mkHomeDeployProfile = name: config: {
  #   user = getUsername name;
  #   path = activate "home-manager" config;
  # };
}
