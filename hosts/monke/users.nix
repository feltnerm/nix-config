{
  config,
  pkgs,
  ...
}: {
  users.users.mark = {
    uid = 1000;
    isNormalUser = true;
    createHome = true;
    home = "/home/mark";
    shell = pkgs.zsh;
    extraGroups = ["users" "wheel" "networkmanager" "nixos-users" "nixbld"];
    initialHashedPassword = "$6$mbLfDRUMNcEFrlIf$/dGxCa760gqNUsZbjT.YvdsfQ0z/Z7BjfpEZslGryUXgTLut.zXBn/mqAWwvq/i.Zbl4OPklk/.AbZnj.8akX/";
  };

  users.users.kram = {
    uid = 1001;
    isNormalUser = true;
    createHome = true;
    home = "/home/kram";
    shells = pkgs.zsh;
    initialHashedPassword = "$6$mbLfDRUMNcEFrlIf$/dGxCa760gqNUsZbjT.YvdsfQ0z/Z7BjfpEZslGryUXgTLut.zXBn/mqAWwvq/i.Zbl4OPklk/.AbZnj.8akX/";
  };
}
