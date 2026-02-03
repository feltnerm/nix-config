{ lib, ... }:
let

  mkModulesOption =
    description:
    lib.mkOption {
      inherit description;
      type = lib.types.listOf lib.types.anything;
      default = [ ];
    };

  mkNixvimOption = lib.types.submodule {
    options = {
      modules = mkModulesOption "A list of modules for nixvim.";
    };
  };

  /**
        resuable options
  */
  mkHomeOption = lib.types.submodule {
    options = {
      modules = mkModulesOption "A list of modules for this home.";
      nixvim = lib.mkOption {
        description = "nixvim configuration for this home.";
        type = mkNixvimOption;
        default = { };
      };
    };
  };

  mkUserOption = lib.types.submodule {
    options = {
      modules = mkModulesOption "A list of modules for this user.";
      home = lib.mkOption {
        description = "home-manager configuration for this user.,";
        type = mkHomeOption;
        default = { };
      };
    };
  };

  mkSystemOption =
    validSystems:
    lib.mkOption {
      description = "The type of system for this host.";
      type = lib.types.enum validSystems;
      default = builtins.head validSystems;
    };

  mkHostOption =
    validSystems:
    lib.types.submodule {
      options = {
        system = mkSystemOption validSystems;
        modules = mkModulesOption "A list of modules for this host.";
        users = lib.mkOption {
          description = "Define users for the system.";
          type = lib.types.lazyAttrsOf mkUserOption;
          default = { };
        };
      };
    };

in
{
  options.feltnerm = {
    theme = lib.mkOption {
      description = "Global default theme for Home Manager profiles.";
      type = lib.types.str;
      default = "catppuccin-mocha";
      example = "gruvbox-dark-hard";
    };

    conventions = {
      configsPath = lib.mkOption {
        description = "Base path to the configurations directory.";
        type = lib.types.path;
        default = ./configs;
        example = lib.literalExpression "./my-configs";
      };

      homeConfigsDirName = lib.mkOption {
        description = ''
          Directory name for standalone home-manager configurations.
          Example: configsPath/home/<username>.
        '';
        type = lib.types.str;
        default = "home";
        example = "home-manager";
      };

      userConfigsDirName = lib.mkOption {
        description = ''
          Directory name for user configurations within OS-specific host configs.
          Example: configsPath/<os>/<hostname>/user/<username>.
        '';
        type = lib.types.str;
        default = "user";
        example = "users";
      };

      userHomeConfigsDirName = lib.mkOption {
        description = ''
          Directory name for home-manager configurations within user configs.
          Example: configsPath/<os>/<hostname>/home/<username>.
        '';
        type = lib.types.str;
        default = "home";
        example = "home";
      };
    };

    darwin = {
      hosts = lib.mkOption {
        description = "Define darwin hosts.";
        type = lib.types.lazyAttrsOf (mkHostOption [
          "aarch64-darwin"
          "x86_64-darwin"
        ]);
        default = { };
        example = lib.literalExpression ''{ my-mac = { system = "aarch64-darwin"; modules = [ ../configs/darwin/my-mac ]; users.mark = { modules = [ ../configs/home/mark ]; }; }; }'';
      };
    };

    nixos = {
      hosts = lib.mkOption {
        description = "Define nixos hosts (physical hardware).";
        type = lib.types.lazyAttrsOf (mkHostOption [ "x86_64-linux" ]);
        default = { };
      };
      vms = lib.mkOption {
        description = "Define nixos VMs (images meant for virtual machines).";
        type = lib.types.lazyAttrsOf (mkHostOption [ "x86_64-linux" ]);
        default = { };
      };
      livecds = lib.mkOption {
        description = "Define nixos livecds (ISO/live environments).";
        type = lib.types.lazyAttrsOf (mkHostOption [ "x86_64-linux" ]);
        default = { };
      };
      wsl = lib.mkOption {
        description = "Define nixos WSL systems.";
        type = lib.types.lazyAttrsOf (mkHostOption [ "x86_64-linux" ]);
        default = { };
      };
    };

    home = {
      users = lib.mkOption {
        description = "(work-in-progress) Define a user whose `$HOME` to manage.";
        type = lib.types.lazyAttrsOf mkHomeOption;
        default = { };
        example = lib.literalExpression "{ mark = { modules = [ ../configs/home/mark ]; nixvim.modules = [ ../configs/nixvim ]; }; }";
      };
    };

    nixvim = {
      configs = lib.mkOption {
        description = "(work-in-progress) Define neovim configs";
        type = lib.types.lazyAttrsOf mkNixvimOption;
        default = { };
        example = lib.literalExpression "{ feltnerm-nvim = { modules = [ ../configs/nixvim ]; }; }";
      };
    };
  };
}
