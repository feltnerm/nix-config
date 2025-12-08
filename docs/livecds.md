# LiveCDs

Generic instructions for building and using LiveCD targets (text and GUI variants).

## Variants
- `livecd`: console-focused minimal environment
- `livecd-gui`: GUI environment (Hyprland) with desktop tooling

## Build
```sh
# From repo root
nix build .#nixosConfigurations.livecd.config.formats.iso
nix build .#nixosConfigurations.livecd-gui.config.formats.iso

# Or via helper
build-vm livecd iso
build-vm livecd-gui iso
```

## Boot and Login
- Boot the ISO in a VM or on hardware
- Default user: `mark`
- When using `run-vm` with SSH forwarding: `ssh -p 2222 mark@localhost`

## Purpose
- `livecd`: rescue, installs, and troubleshooting
- `livecd-gui`: test desktop configs, quick demos, graphical tooling

## Cloud-init seed (optional)
```sh
scripts/cloud-init-seed.sh mark ~/.ssh/id_ed25519.pub seed.iso
# Then boot ISO with `-cdrom seed.iso` or via `run-vm`
```

## Notes
- Host-specific overrides live under `configs/nixos/livecd*/`
