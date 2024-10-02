{
  self,
  inputs,
  stateVersion,
  stateVersionDarwin,
  ...
}: let
  homeConfiguration = "${self}/home";
  hostConfiguration = "${self}/system";
  homeProfiles = "${homeConfiguration}/profiles";
  homeModules = "${homeConfiguration}/modules";
  hostModules = "${hostConfiguration}/modules";
  darwinModules = "${hostConfiguration}/modules/darwin";
  generalModules = "${self}/modules";
in {
  # create a home-manager configuration
  mkHome = {
    username ? "mark",
    hostname ? "nixos",
    platform ? "x86_64-linux",
    extraConfig ? {},
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          extraConfig
          generalModules
          homeModules
          homeProfiles
          hostname
          inputs
          platform
          self
          stateVersion
          username
          ;

        modules = [
          "${homeConfiguration}"
          extraConfig
        ];
      };
    };

  # create a nixos host
  # TODO optional home-manager
  mkHost = {
    hostname ? "nixos",
    username ? "mark",
    platform ? "x86_64-linux",
    extraConfig ? {},
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          extraConfig
          generalModules
          homeModules
          homeProfiles
          hostModules
          hostname
          inputs
          platform
          self
          stateVersion
          username
          ;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        "${hostConfiguration}"
        "${homeConfiguration}"
        extraConfig
      ];
    };

  # create a darwin host
  mkHostDarwin = {
    hostname ? "nix-darwin",
    username ? "mark",
    platform ? "x86_64-darwin",
    extraConfig ? {},
  }:
    inputs.darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          darwinModules
          extraConfig
          generalModules
          homeModules
          homeProfiles
          hostname
          inputs
          platform
          self
          stateVersion
          stateVersionDarwin
          username
          ;
      };

      modules = [
        inputs.home-manager.darwinModules.home-manager
        "${hostConfiguration}"
        "${homeConfiguration}"
        extraConfig
      ];
    };
}
