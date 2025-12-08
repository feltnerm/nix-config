# Hosts

Generic instructions for adding, installing, and maintaining NixOS hosts in this repo.

## Overview
- Hosts live under `configs/nixos/<host>/`
- Common options and modules in `modules/nixos/*`
- Flake wiring in `flake/nixos.nix` and host entries in `flake/default.nix`

## Add a New Host
1. Create `configs/nixos/<host>/default.nix` with imports of common modules
2. Add `hardware.nix` (and `disko.nix` if using disko/ZFS)
3. Add `home/mark.nix` and `user/mark.nix` or desired users
4. Update flake outputs to include `<host>` (see `flake/nixos.nix`)
5. Create `README.md` with host-specific notes only

## Install (Generic)
```bash
# Partition and mount (example ext4)
DISK=/dev/nvme0n1
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB; parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart swap linux-swap 512MiB 8.5GiB
parted "$DISK" -- mkpart root ext4 8.5GiB 100%
mkfs.vfat -n BOOT ${DISK}p1
mkswap -L swap ${DISK}p2
mkfs.ext4 -L nixos ${DISK}p3
swapon /dev/disk/by-label/swap
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot

# Install via flake
cd /mnt
sudo git clone https://github.com/feltnerm/nix-config
cd nix-config
sudo nixos-install --flake .#<host>
```

## Disko/ZFS (optional)
```bash
nix run github:nix-community/disko -- --mode zap_create_mount configs/nixos/<host>/hardware.nix
```
Verify by-id device paths before running.

## Post-Install Tasks
- Network: ensure connectivity (NetworkManager)
- Audio: PipeWire functioning
- GUI: Hyprland scaling/touchpad settings as needed
- Bluetooth: optional enablement

## Maintenance
- Rebuild: `sudo nixos-rebuild switch --flake .#<host>`
- Update inputs: `nix flake update`
- Pin versions: use `flake.lock` and `flake-modules.nix` as needed

## Notes
- Keep host README focused on specific quirks/tweaks (hardware, layout, roles)
- For VMs, ISOs, and LiveCDs, see `docs/vms.md`, `docs/iso.md`, and `docs/livecds.md`
