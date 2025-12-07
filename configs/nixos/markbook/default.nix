{
  inputs,
  pkgs,
  ...
}:
{
  # Markbook (MacBook Pro 13" Late 2013) main system config
  # Notes:
  # - Uses simple ext4 filesystem (see hardware.nix for disk setup)
  # - Laptop power management via TLP and thermald
  # - GUI via Hyprland + greetd; HiDPI scaling can be tuned in home-manager
  # - Kanata keyboard mapping included for external Keychron K2

  imports = [
    # MacBook Pro 11,1 specific hardware profile (falls back to common if unavailable)
    inputs.hardware.nixosModules.apple-macbook-pro-11-1
    ./hardware.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Hostname
    networking.hostName = "markbook";

    # Trust local user for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    # Networking basics
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # User shell
    users.users.mark.shell = pkgs.zsh;

    # Base services
    services.openssh.enable = true;
    services.pipewire.enable = true;

    # GUI setup: greetd + Hyprland
    services.greetd.enable = true;
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };

    environment.systemPackages = with pkgs; [
      kitty
      blueman
      light
      brightnessctl
      powertop
    ];

    # Laptop power management
    services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };

    # Intel thermals
    services.thermald.enable = true;

    # Backlight control
    programs.light.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

    # Kanata keyboard config (external Keychron K2). Full mapping here; device/uinput in hardware.nix
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

    # Notes for future fine-tuning:
    # - Hyprland HiDPI scaling: set monitor scale in home-manager (e.g., 2.0 or 1.5)
    # - Function keys behavior: adjust hid_apple.fnmode via kernelParams
    # - Add brightnessctl if preferred over light
    # - Consider powertop for additional tuning (package only)
  };
}
