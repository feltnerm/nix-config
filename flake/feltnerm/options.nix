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
        description = "Define nixos hosts.";
        type = lib.types.lazyAttrsOf (mkHostOption [ "x86_64-linux" ]);
        default = { };
        example = lib.literalExpression ''{ codemonkey = { system = "x86_64-linux"; modules = [ ../configs/nixos/codemonkey ]; users.mark = { modules = [ ../configs/nixos/codemonkey/user/mark.nix ]; home.modules = [ ../configs/home/mark ../configs/nixos/codemonkey/home/mark.nix ]; }; }; }'';
      };
    };

    home = {
      users = lib.mkOption {
        description = "(work-in-progress) Define a user whose `$HOME` to manage.";
        type = lib.types.lazyAttrsOf mkHomeOption;
        default = { };
        example = lib.literalExpression ''{ mark = { modules = [ ../configs/home/mark ]; nixvim.modules = [ ../configs/nixvim ]; }; }'';
      };
    };

    nixvim = {
      configs = lib.mkOption {
        description = "(work-in-progress) Define neovim configs";
        type = lib.types.lazyAttrsOf mkNixvimOption;
        default = { };
        example = lib.literalExpression ''{ feltnerm-nvim = { modules = [ ../configs/nixvim ]; }; }'';
      };
    };
  };
}
