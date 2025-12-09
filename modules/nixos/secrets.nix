{
  config,
  lib,
  hostname,
  ...
}:
let
  cfg = config.feltnerm.secrets;
  hostSecretPath = name: ../../secrets/hosts/${hostname}/${name}.age;
  userSecretPath = user: name: ../../secrets/users/${user}/${name}.age;
in
{
  options.feltnerm.secrets = {
    enable = lib.mkEnableOption "Enable secrets management with agenix";

    hostSecrets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of host secret names (files in secrets/hosts/{hostname}/)";
      example = [ "opencode-api-token" "wifi-password" ];
    };

    userSecrets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {};
      description = "Per-user secrets (username -> list of secret names)";
      example = { mark = [ "opencode-api-token" "github-token" ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = lib.mkMerge [
      (lib.listToAttrs (map (name: {
        name = "host-${name}";
        value = {
          file = hostSecretPath name;
        };
      }) cfg.hostSecrets))

      (lib.mkMerge (lib.mapAttrsToList (user: secrets:
        lib.listToAttrs (map (name: {
          name = "${user}-${name}";
          value = {
            file = userSecretPath user name;
            owner = user;
            group = "users";
            mode = "0400";
          };
        }) secrets)
      ) cfg.userSecrets))
    ];

    environment.systemPackages = [ config.age.package ];
  };
}
