{
  den,
  lib,
  ...
}:
{
  imports = [
    ./feltnerm
  ];

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default.includes = [
    den.provides.hostname
  ];

  den.default.user = {
    isNormalUser = lib.mkDefault true;
    createHome = lib.mkDefault true;
  };

}
