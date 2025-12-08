{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./hardware.nix
    ../../../modules/nixos/wsl-base.nix
  ];

  config = {
    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Trust mark for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    # User shell
    users.users.mark.shell = pkgs.zsh;

    # SSH server (left enabled; can be tuned later)
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.settings.PasswordAuthentication = false;

    # Minimal base dev packages; majority comes from home-manager
    environment.systemPackages = with pkgs; [
      vim
      git
      tmux
      htop
      curl
      wget
    ];
  };
}
