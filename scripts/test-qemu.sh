#!/bin/bash
# ==============================================================================
# AeroGaming OS - QEMU Hardware Emulation Test Runner
# Replicates Lenovo V15 ADA specs: 2 vCPUs, 4GB RAM, UEFI, simulated HDD
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ISO_IMAGE="${1:-$PROJECT_ROOT/output/AeroGamingOS-Lenovo-V15-ADA-amd64.iso}"

if [ ! -f "$ISO_IMAGE" ]; then
    echo "[-] Error: ISO image not found at $ISO_IMAGE"
    echo "    Build the ISO first with: sudo ./scripts/build-iso.sh"
    exit 1
fi

echo "================================================================================"
echo " Starting AeroGaming OS QEMU Test Runner"
echo " Target Spec: Lenovo V15 ADA (Athlon 3050U 2-Cores, 4096 MB RAM, UEFI)"
echo " Image: $ISO_IMAGE"
echo "================================================================================"

# Locate OVMF UEFI firmware
OVMF_PATH="/usr/share/OVMF/OVMF_CODE.fd"
if [ ! -f "$OVMF_PATH" ]; then
    OVMF_PATH="/usr/share/ovmf/OVMF.fd"
fi

QEMU_ARGS=(
    -enable-kvm
    -cpu host
    -smp 2
    -m 4096
    -vga virtio
    -display gtk,gl=on
    -cdrom "$ISO_IMAGE"
    -boot d
    -net nic,model=virtio -net user
)

if [ -f "$OVMF_PATH" ]; then
    echo "[+] Using UEFI OVMF firmware: $OVMF_PATH"
    QEMU_ARGS+=(-bios "$OVMF_PATH")
else
    echo "[!] Warning: OVMF UEFI firmware not found. Testing in Legacy BIOS mode."
fi

qemu-system-x86_64 "${QEMU_ARGS[@]}"

