#!/usr/bin/env bash
set -euo pipefail

# Simple QEMU runner for built VM images
# Usage:
#   scripts/qemu-run.sh <image> [--memory 4096] [--cpus 2] [--display sdl|none]
# Examples:
#   scripts/qemu-run.sh result --memory 4096 --cpus 2
#   scripts/qemu-run.sh ./result --display none

IMAGE=${1:-}
if [[ -z $IMAGE ]]; then
  echo "Usage: $0 <image> [--memory 4096] [--cpus 2] [--display sdl|none]" >&2
  exit 1
fi

MEMORY=4096
CPUS=2
DISPLAY=sdl

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
  --memory)
    MEMORY="$2"
    shift 2
    ;;
  --cpus)
    CPUS="$2"
    shift 2
    ;;
  --display)
    DISPLAY="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1" >&2
    exit 1
    ;;
  esac
done

IMG_REAL=$(readlink -f "$IMAGE" 2>/dev/null || echo "$IMAGE")

# Choose correct drive interface based on image type
IFACE=virtio
# Detect platform acceleration
ACCEL_ARGS=()
UNAME=$(uname -s)
if [[ $UNAME == "Darwin" ]]; then
  ACCEL_ARGS+=(-accel hvf)
else
  # Try KVM on Linux; ignore if unavailable
  if [[ -e /dev/kvm ]]; then
    ACCEL_ARGS+=(-enable-kvm)
  fi
fi

if [[ $IMG_REAL == *.iso ]]; then
  # Boot ISO with CD-ROM
  exec qemu-system-x86_64 \
    -m "$MEMORY" \
    -smp "$CPUS" \
    "${ACCEL_ARGS[@]}" \
    -cpu host \
    -device virtio-net-pci \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -display "$DISPLAY" \
    -boot d \
    -cdrom "$IMG_REAL"
else
  # Boot disk image (qcow2/raw)
  exec qemu-system-x86_64 \
    -m "$MEMORY" \
    -smp "$CPUS" \
    "${ACCEL_ARGS[@]}" \
    -cpu host \
    -device virtio-net-pci \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -display "$DISPLAY" \
    -drive file="$IMG_REAL",if=$IFACE,format=qcow2
fi
