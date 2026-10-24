#!/bin/bash
# ==============================================================================
# AeroGaming OS - Prism Launcher Auto-Installer
# Ultra-lightweight open-source Minecraft launcher
# ==============================================================================

set -euo pipefail

echo "================================================================================"
echo " Installing Prism Launcher for AeroGaming OS"
echo "================================================================================"

# Check if already installed
if command -v prismlauncher >/dev/null 2>&1; then
    echo "[+] Prism Launcher is already installed."
    exit 0
fi

# Add Prism Launcher Debian repository
echo "[*] Adding Prism Launcher GPG key and APT repository..."
sudo apt-get install -y --no-install-recommends ca-certificates curl gnupg

sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://raw.githubusercontent.com/PrismLauncher/PrismLauncher/develop/keys/prismlauncher.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/prismlauncher.gpg
sudo chmod a+r /etc/apt/keyrings/prismlauncher.gpg

echo "deb [signed-by=/etc/apt/keyrings/prismlauncher.gpg] https://prismlauncher.moe/debian/ bookworm main" | sudo tee /etc/apt/sources.list.d/prismlauncher.list

echo "[*] Updating package list and installing Prism Launcher..."
sudo apt-get update
sudo apt-get install -y prismlauncher

echo "================================================================================"
echo " [+] Prism Launcher successfully installed!"
echo " Launch it from Whisker Menu or run: prismlauncher"
echo "================================================================================"

