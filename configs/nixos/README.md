# NixOS Install Guide (Generic)

This guide provides common steps to install any NixOS host in this repo. Host-specific notes live in each system folder (e.g., `configs/nixos/<host>/README.md`).

## Prereqs
- Boot a NixOS installer USB
- Connect to network (e.g., `nmtui`)
- Identify target disk (e.g., `lsblk`) and verify by-id paths if using ZFS/disko
- Mount the target filesystem(s) under `/mnt`
- Clone this repo to `/mnt`

## Partitioning (ext4 example)
- EFI (vfat): 512MB, label `BOOT`
- Swap: suitable size (e.g., 4–8GB)
- Root (ext4): remainder, label `nixos`

Example commands:
```bash
DISK=/dev/nvme0n1 # or /dev/sda
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB; parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart swap linux-swap 512MiB 8.5GiB
parted "$DISK" -- mkpart root ext4 8.5GiB 100%

# NVMe uses p1/p2/p3; SATA uses 1/2/3
mkfs.vfat -n BOOT ${DISK}p1
mkswap -L swap ${DISK}p2
mkfs.ext4 -L nixos ${DISK}p3

swapon /dev/disk/by-label/swap
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

## ZFS via disko (where applicable)
Some hosts use disko to define ZFS layouts.
```bash
nix run github:nix-community/disko -- --mode zap_create_mount configs/nixos/<host>/hardware.nix
```
Verify device IDs in the host `hardware.nix` before running.

## Install using flake
```bash
cd /mnt
sudo git clone https://github.com/feltnerm/nix-config
cd nix-config
sudo nixos-install --flake .#<host>
```
Set the root password when prompted, then reboot.

## Post-Install Checks
- Network connectivity (NetworkManager)
- Bluetooth (if applicable)
- Keyboard and touchpad behavior
- Display scaling (Wayland/Hyprland)
- Audio via PipeWire

## Notes
- Filesystem labels in `hardware.nix` must match actual disk labels.
- For Apple keyboards: `boot.kernelParams = [ "hid_apple.fnmode=2" ];` to default F1–F12.
- Optional power tuning: `powertop --auto-tune`.
