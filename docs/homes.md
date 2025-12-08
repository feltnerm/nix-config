# Homes

Generic instructions for adding and using Home Manager configurations in this repo.

## Overview
- Home configs live under `configs/home/<user>/` and `modules/home-manager/...`
- Managed via flakes and integrated with NixOS or Darwin as appropriate

## Add a New Home
1. Create `configs/home/<user>/default.nix`
2. Reference shared modules from `modules/home-manager/...` as needed
3. Add flake outputs in `flake/home.nix` (if not already templated)

## Activate on NixOS
```sh
home-manager switch --flake .#<user>@<host>
```
Prereqs: Home Manager installed and enabled for the target user.

## Activate on macOS (Darwin)
```sh
darwin-rebuild switch --flake .#darwin
# Or user-specific:
home-manager switch --flake .#<user>@darwin
```

## Common Tasks
- Update packages: edit module options under `modules/home-manager/*`
- Add CLI tools: extend `programs.*` entries
- Theme: adjust Stylix/Catppuccin options in `modules/home-manager/stylix.nix`

## Notes
- For user-specific tweaks, document in `configs/home/<user>/README.md`
- See `flake/home.nix` for available outputs and variants
