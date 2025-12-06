{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
  ];

  config = {
    # Boot loader (EFI via systemd-boot)
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false; # rely on BIOS boot order

    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Trust local user for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    # Networking basics handled per host here
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # User shell
    users.users.mark.shell = pkgs.zsh;

    # Base services
    services.openssh.enable = true;
    services.pipewire.enable = true;

    # GUI (greeter, hyprland, ...)
    services.greetd.enable = true;
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };
    environment.systemPackages = [ pkgs.kitty ];

    # Kanata keyboard: keep full mapping here; devices/uinput rules live in hardware.nix
    services.kanata.enable = true;
    services.kanata.keyboards.internalKeyboard.config = ''
      (defsrc
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet rctl
      )

      (defalias
        cec (tap-hold 200 200 esc lctl)
        sym (tap-hold 200 200 tab (layer-toggle symbols))
      )

      (deflayer default
        esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        @sym q    w    e    r    t    y    u    i    o    p    [    ]    \
        @cec a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet rctl
      )

      (deflayer symbols
        _    _    _    _    _    _    _    _    _    _    _    _    _
        _    S-1  S-2  S-3  S-4  S-5  S-6  S-7  S-8  S-9  S-0  _    _    _
        _    S-5  S-6  S-7  S-8  _    _    _    _    S-9  S-0  _    _    _
        _    _    _    del  _    _    left down up   rght _    _    _
        _    _    _    _    _    _    _    _    _    _    _    _
        _    _    _              _              _    _    _
      )
    '';
  };
}
