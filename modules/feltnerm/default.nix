{
  config,
  den,
  inputs,
  lib,
  ...
}:
let
  unfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
  extraSpecialArgs = { inherit inputs den; };
  sharedSystemModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # shared locale settings
      time.timeZone = lib.mkDefault "America/Chicago";

      # shared documentations settings
      documentation = lib.mkIf config.documentation.enable {
        man.enable = true;
        info.enable = true;
      };

      # shared nix settings
      nix = {
        optimise.automatic = lib.mkDefault true;
        gc.automatic = lib.mkDefault true;
        settings = {
          # enable nix flake support
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          # Use shared binary caches
          extra-substituters = [ "https://feltnerm.cachix.org" ];
          extra-trusted-public-keys = [
            "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
          ];

        };
      };

      # shared nixpkgs settings
      nixpkgs.config = {
        allowUnfree = lib.mkDefault true;
      };

      # shared environment settings
      environment = {
        shells = [
          pkgs.bash
          pkgs.zsh
        ];

        systemPackages = with pkgs; [
          bash
          zsh
          vim
          git
          man
        ];
      };

      programs = {
        zsh.enable = lib.mkDefault true;
      };
    };
in
{
  imports = [
    ./developer/default.nix
    ./gui/default.nix
    ./home-cli-minimal.nix
    ./ssh/default.nix
    ./network/default.nix
    ./security/default.nix
    ./kanata/default.nix
    ./smart-card/default.nix
    ./audio.nix
    ./hardware-intel/default.nix
    ./base-profiles/default.nix
    ./bluetooth.nix
    ./laptop.nix
    ./nixvim-default.nix
    ./home-wsl-vars.nix
    ./wsl.nix
    ./user-mark/default.nix
    ./theme/default.nix
  ];

  den.default.nixos = {
    config = {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = unfreePredicate;
      };

      home-manager.extraSpecialArgs = extraSpecialArgs;

      # Network defaults
      networking = {
        networkmanager.enable = lib.mkDefault true;
        firewall = {
          enable = lib.mkDefault true;
        };
        useDHCP = lib.mkDefault true;
      };

      # System defaults
      system = {
        copySystemConfiguration = lib.mkDefault false;

        # auto-upgrade the system weekly
        autoUpgrade = lib.mkIf config.system.autoUpgrade.enable {
          dates = lib.mkDefault "weekly";
          allowReboot = lib.mkDefault false;
        };
      };

      # Console defaults
      console = {
        # use xkbOptions in tty.
        useXkbConfig = lib.mkDefault true;
        # TODO set a console font (for widescreen can use `config.feltnerm.hardware.display`)
        # font = "Lat2-Terminus16";
        # keyMap = cfg.locale.keymap;
      };

      # Map Caps Lock to Escape via XKB options
      services.xserver.xkb.options = lib.mkDefault "caps:escape";

      documentation = {
        # includeAllModules = lib.mkDefault true;
        dev.enable = lib.mkDefault true;
        man = {
          cache.enable = lib.mkDefault true;
        };
      };

      home-manager.backupFileExtension = lib.mkDefault "bak";
      boot.zfs.forceImportRoot = lib.mkDefault false;
    };

    imports = [
      sharedSystemModule
      inputs.agenix.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.nix-topology.nixosModules.default
    ];
  };

  den.default.darwin = {
    config = {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = unfreePredicate;
      };

      home-manager.extraSpecialArgs = extraSpecialArgs;
      home-manager.backupFileExtension = lib.mkDefault "bak";
    };

    imports = [
      sharedSystemModule
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.agenix.darwinModules.default
    ];
  };

  den.default.homeManager = {
    config = {
      programs.home-manager.enable = lib.mkForce true;

      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = unfreePredicate;
      };
    };
  };

  # Home submodules always have class = "homeManager" (declared option in
  # upstream homeType), so no class check is needed here.
  den.schema.home = _: {
    instantiate = lib.mkDefault (
      { pkgs, modules }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs modules;
        inherit extraSpecialArgs;
      }
    );
  };
}
