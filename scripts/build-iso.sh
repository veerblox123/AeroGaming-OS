#!/bin/bash
# ==============================================================================
# AeroGaming OS - Reproducible ISO Build Script
# Targets Lenovo V15 ADA Laptop (AMD Athlon 3050U + Vega 3 + 4GB RAM)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_ROOT/live-build"
OUTPUT_DIR="$PROJECT_ROOT/output"

echo "================================================================================"
echo "          AeroGaming OS (Lenovo V15 ADA Edition) ISO Builder                    "
echo "================================================================================"
echo "Project Root: $PROJECT_ROOT"
echo "Build Directory: $BUILD_DIR"
echo "================================================================================"

# Verify root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Error: This script must be run as root (or with sudo) to build the live ISO."
    echo "    Usage: sudo ./scripts/build-iso.sh"
    exit 1
fi

# 1. Install Host Dependencies
echo "[1/5] Checking and installing build dependencies..."
apt-get update
apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-utils \
    mtools \
    dosfstools \
    grub-pc-bin \
    grub-efi-amd64-bin \
    rsync \
    git \
    curl \
    ca-certificates

# 2. Enter Build Directory & Clean previous builds
cd "$BUILD_DIR"
echo "[2/5] Cleaning previous build artifacts..."
lb clean --purge

# 3. Configure Live-Build
echo "[3/5] Configuring live-build parameters..."
# Ensure auto/config is executable
chmod +x auto/config
lb config

# Ensure all hooks are executable
chmod +x config/hooks/normal/*.hook.chroot 2>/dev/null || true

# 4. Execute Build
echo "[4/5] Building AeroGaming OS live ISO image (this may take 10-20 minutes)..."
lb build 2>&1 | tee "$PROJECT_ROOT/build.log"

# 5. Collect and Hash Artifacts
echo "[5/5] Processing build artifacts..."
mkdir -p "$OUTPUT_DIR"

ISO_FILE=$(ls -t "$BUILD_DIR"/*.iso 2>/dev/null | head -n 1 || true)

if [ -n "$ISO_FILE" ] && [ -f "$ISO_FILE" ]; then
    FINAL_ISO="$OUTPUT_DIR/AeroGamingOS-Lenovo-V15-ADA-amd64.iso"
    mv "$ISO_FILE" "$FINAL_ISO"
    
    # Compute Checksum
    cd "$OUTPUT_DIR"
    sha256sum "$(basename "$FINAL_ISO")" > "$(basename "$FINAL_ISO").sha256"
    
    echo ""
    echo "================================================================================"
    echo "                   BUILD SUCCESSFUL!                                            "
    echo "================================================================================"
    echo " ISO Image: $FINAL_ISO"
    echo " Size: $(du -h "$FINAL_ISO" | awk '{print $1}')"
    echo " SHA256: $(cat "$FINAL_ISO.sha256")"
    echo "================================================================================"
    echo " To flash this ISO to a USB drive on Windows:"
    echo "   1. Open Rufus (https://rufus.ie)"
    echo "   2. Select your USB drive and select the .iso file."
    echo "   3. Choose 'GPT' partition scheme and 'UEFI (non-CSM)' target."
    echo "   4. Click Start (use ISO or DD mode when prompted)."
    echo "================================================================================"
else
    echo "[-] Error: ISO build completed but no .iso file was generated. Check build.log for errors."
    exit 1
fi

