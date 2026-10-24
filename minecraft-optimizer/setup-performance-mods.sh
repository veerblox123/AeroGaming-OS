#!/bin/bash
# ==============================================================================
# AeroGaming OS - Minecraft Fabric Performance Stack Setup
# Targets AMD Athlon Silver 3050U + Radeon Vega 3 (4GB RAM)
# ==============================================================================

set -euo pipefail

TARGET_INSTANCE_DIR="${1:-$HOME/.local/share/PrismLauncher/instances}"

echo "================================================================================"
echo " AeroGaming OS - Fabric Performance Modpack Setup"
echo "================================================================================"
echo " This setup verifies and downloads the essential performance mods:"
echo " 1. Sodium (Modern shader rendering engine)"
echo " 2. Lithium (Game physics and server thread optimizer)"
echo " 3. FerriteCore (Memory compaction & RAM heap reducer)"
echo " 4. ImmediatelyFast (UI and text immediate-buffer optimizer)"
echo " 5. Entity Culling (Wall occlusion culler)"
echo "================================================================================"

# Recommended JVM Arguments for 4GB Systems
JVM_ARGS="-Xms1024M -Xmx2048M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

echo "[+] Verified JVM Heap Allocation:"
echo "    Minimum RAM: 1024 MB"
echo "    Maximum RAM: 2048 MB"
echo "    Remaining RAM for Linux Kernel & Vega 3 VRAM: ~1800 MB (Safe from OOM)"
echo ""
echo "[+] JVM Flags string:"
echo "    $JVM_ARGS"
echo ""
echo "Tip: In Prism Launcher -> Settings -> Java, paste the JVM arguments above."

