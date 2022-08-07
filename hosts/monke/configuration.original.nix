# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    <home-manager/nixos>
  ];

  boot.loader = {
    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
      useOSProber = false;
      #memtest86.enable = true;
    };

    efi = {
      canTouchEfiVariables = true;
    };

    systemd-boot = {enable = false;};
  };

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/d3aa3dac-8702-4b08-9f4b-c7f86fb685e3";
      fallbackToPassword = true;
      preLVM = true;
      allowDiscards = true;
    };
  };

  fileSystems = {
    "/boot" = {
      label = "MONKEBOOT";
      options = ["noatime" "nodiratime" "discard"];
    };

    "/" = {
      label = "NIXROOT";
      options = ["noatime" "nodiratime" "discard"];
    };

    "/home" = {
      label = "MONKEHOME";
      options = ["noatime" "nodiratime" "discard"];
    };

    "/opt/os/arch" = {
      label = "ARCHROOT";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "discard"];
    };

    "/opt/os/ubuntu" = {
      label = "UBUNTUROOT";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "discard"];
    };
  };

  networking = {
    hostName = "monke-nixos"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
  };

  time.timeZone = "America/Chicago";

  security.sudo.enable = true;
  systemd.enableEmergencyMode = false;

  users.mutableUsers = false;
  users.groups = {nixos-users = {};};
  users.users = {
    root = {
      hashedPassword = "!"; # disable root password
    };
    mark = {
      uid = 1000;
      createHome = true;
      home = "/home/mark";
      isNormalUser = true;
      initialHashedPassword = "$6$mbLfDRUMNcEFrlIf$/dGxCa760gqNUsZbjT.YvdsfQ0z/Z7BjfpEZslGryUXgTLut.zXBn/mqAWwvq/i.Zbl4OPklk/.AbZnj.8akX/";
      #group = "mark";
      extraGroups = ["users" "wheel" "networkmanager" "nixos-users"];

      packages = with pkgs; [
        git
        zsh
        neovim
        vim
      ];
    };
  };

  home-manager.users.mark = {pkgs, ...}: {
    home.packages = [pkgs.atool pkgs.httpie];
    programs.bash.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkbOptions in tty.
  #};

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
