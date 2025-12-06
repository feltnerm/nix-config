#!/usr/bin/env bash
# Helper functions for the feltnerm VM devshell

# build-vm <host> <output>
# output: one of system build targets (vm, vmWithBootLoader, vmWithDisko)
#         or format targets (iso, qcow, vmware, virtualbox, etc.)
build-vm() {
  local host=${1:-}
  local output=${2:-}
  if [[ -z $host || -z $output ]]; then
    echo "Usage: build-vm <host> <output>" >&2
    echo "Examples:" >&2
    echo "  build-vm virtmark vmWithBootLoader" >&2
    echo "  build-vm virtmark-gui qcow" >&2
    echo "  build-vm codemonkey iso" >&2
    return 1
  fi

  # Validate host exists in flake
  if ! nix eval ".#nixosConfigurations.$host" >/dev/null 2>&1; then
    echo "Unknown host: $host" >&2
    echo "Hint: check available hosts via 'nix flake show' under nixosConfigurations." >&2
    return 2
  fi

  # Determine target path and validate output attr exists
  local attr
  case "$output" in
  vm | vmWithBootLoader | vmWithDisko)
    attr="nixosConfigurations.$host.config.system.build.$output"
    ;;
  *)
    attr="nixosConfigurations.$host.config.formats.$output"
    ;;
  esac

  if ! nix eval ".#$attr" >/dev/null 2>&1; then
    echo "Unknown output '$output' for host '$host'" >&2
    echo "Try one of: vm, vmWithBootLoader, vmWithDisko, iso, qcow (and other nixos-generators formats)" >&2
    return 3
  fi

  nix build ".#$attr"
}

seed-cloud-init() {
  scripts/cloud-init-seed.sh "${1:-mark}" "${2:-$HOME/.ssh/id_ed25519.pub}" "${3:-seed.iso}"
}

run-vm() {
  scripts/qemu-run.sh "${1:-./result}" --memory "${VM_MEMORY:-4096}" --cpus "${VM_CPUS:-2}"
}
