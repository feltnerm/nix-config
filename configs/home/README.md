# Home Manager Guide (Generic)

Although Home Manager can be used in standalone mode, this repo generally integrates Home Manager as a module within system configurations (NixOS or nix-darwin). Use standalone only when appropriate.

System-specific details live under `configs/nixos/<host>/home` or `configs/darwin/<host>/home`.

## Prereqs
- Nix installed
- Home Manager available (flake input)

## Apply home config via flake (standalone)
```bash
# from repo root
home-manager switch --flake .#<user>@<host>
```

## As a module (preferred)
Apply via your system rebuild command, which includes Home Manager:
```bash
# NixOS
sudo nixos-rebuild switch --flake .#<host>

# macOS (nix-darwin)
darwin-rebuild switch --flake .#<host>
```

## Notes
- Some modules expect system packages; ensure your system config includes required packages/services.
- For Wayland/Hyprland, configure scaling in your home config.
