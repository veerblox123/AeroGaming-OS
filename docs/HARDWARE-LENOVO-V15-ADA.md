# Lenovo V15 ADA Hardware Architecture & OS Optimization Guide

This document provides a technical overview of the **Lenovo V15 ADA laptop** hardware architecture and the specific optimizations applied in **AeroGaming OS**.

---

## 1. Laptop Hardware Specifications

| Component | Hardware Specification | Architectural Notes |
| :--- | :--- | :--- |
| **Laptop Model** | Lenovo V15 ADA (Type 82C7) | Ultra-budget 15.6" laptop platform |
| **Processor (CPU)** | AMD Athlon Silver 3050U | 2 Cores, 2 Threads, 2.3 GHz base / 3.2 GHz boost, Zen 14nm (Dali / Raven2 APU), 4MB L3 Cache |
| **Graphics (GPU)** | Integrated AMD Radeon Vega 3 | GCN 5th Gen, 3 Compute Units, 192 Stream Processors, 1100 MHz max clock |
| **System Memory** | 4 GB DDR4 2400 MHz | Shared memory architecture. BIOS pre-allocates 512 MB to 2 GB for VRAM |
| **Internal Storage** | 1 TB 5400 RPM SATA HDD | Mechanical rotational hard disk (high seek latency, low 4K random I/O) |
| **Wireless (Wi-Fi/BT)** | Realtek RTL8821CE or RTL8822CE | 802.11ac 1x1 / 2x2 Wi-Fi + Bluetooth 4.2 / 5.0 (PCIe / USB interface) |
| **Display Panel** | 15.6" HD (1366x768) or FHD (1920x1080) | 60 Hz 220 nits TN / IPS panel |
| **Battery & Charging** | 35 Wh Li-ion, 65W AC Adapter | Supports Lenovo Ideapad Battery Conservation Mode |

---

## 2. Core Architectural Bottlenecks & Solutions

### Bottleneck 1: 4 GB System RAM with Shared Vega 3 VRAM
- **Problem**: Integrated Radeon Vega 3 shares physical RAM with the system. At default BIOS settings, 512 MB to 2 GB of RAM is reserved as VRAM, leaving only ~2.8 GB to 3.5 GB of addressable RAM for Linux and applications. Running modern games like Minecraft Java on 4 GB of RAM frequently causes memory exhaustion and crashes.
- **AeroGaming OS Solution**:
  1. **ZRAM with `zstd` compression**: Creates a virtual compressed in-RAM swap device matching 100% of RAM. With `zstd` compression ratio of 2.5:1 to 3:1, 4 GB of RAM holds roughly 6.5 GB to 7.5 GB of uncompressed data with near-zero latency.
  2. **Aggressive Swappiness (`vm.swappiness = 180`)**: Proactively pushes inactive anonymous memory into compressed ZRAM, preserving uncompressed memory for active game rendering and file cache.
  3. **Zero-Latency Clustering (`vm.page-cluster = 0`)**: Reads and writes single 4 KB pages directly into ZRAM instead of sequential 8-page blocks meant for mechanical disks.

### Bottleneck 2: 1 TB 5400 RPM SATA HDD (Random I/O Latency)
- **Problem**: 5400 RPM HDDs have seek times around 15–20 ms. When background processes write logs or flush caches, mechanical disk head thrashing causes severe audio stutter, mouse hitching, and game freezes.
- **AeroGaming OS Solution**:
  1. **BFQ (Budget Fair Queueing) Scheduler**: Applied via udev rules for all rotational drives (`rotational=1`). BFQ assigns proportional bandwidth slices and prioritizes interactive audio, mouse input, and foreground windows, ensuring that background file transfers or Minecraft world saves never freeze the desktop.
  2. **Low-Latency Flush Tweaks**: `vm.dirty_background_ratio = 5` and `vm.dirty_ratio = 10`. Forces Linux to flush writes to disk in tiny 5% increments rather than holding 300 MB of dirty pages and causing a 10-second freeze when flushing to the slow 5400 RPM drive.
  3. **VFS Metadata Preservation (`vm.vfs_cache_pressure = 50`)**: Prevents the kernel from evicting directory entries and file inodes, eliminating repeated disk head seeking when opening directories.

### Bottleneck 3: AMD Athlon Silver 3050U (2 Cores / 2 Threads)
- **Problem**: With only 2 CPU threads, background services like CUPS (printing), Avahi (mDNS), Tracker (GNOME indexing), or telemetry quickly saturate the CPU, dropping game framerates.
- **AeroGaming OS Solution**:
  1. **Stripped Desktop Footprint**: XFCE 4.18 with bloat daemons masked. Idle CPU load is under 0.5%.
  2. **Feral GameMode Integration**: Automatically switches the CPU governor to `performance`, sets game process niceness to `-10`, and raises I/O priority to real-time (`ioprio=0`).
  3. **Full Unredirection**: Picom is configured with `unredir-if-fullscreen = true`, and GameMode hooks kill Picom during gaming, transferring direct buffer ownership to the Vega 3 GPU.

### Bottleneck 4: Realtek RTL8821CE Wi-Fi Drops Under Heavy Load
- **Problem**: The Realtek RTL8821CE PCIe Wi-Fi chip suffers from aggressive PCIe Active State Power Management (ASPM), causing connection drops and high ping spikes on Minecraft multiplayer servers.
- **AeroGaming OS Solution**:
  - Kernel module options `/etc/modprobe.d/lenovo-v15.conf`:
    ```ini
    options rtw88_pci disable_aspm=y disable_msi=n
    options rtw88_core disable_lps_deep=y
    ```
  - Eliminates low-power sleep collapse during active network sessions.

---

## 3. Lenovo Specific ACPI & Battery Longevity

The Lenovo V15 ADA features Lenovo Ideapad ACPI subsystem (`ideapad_laptop`).
- **Battery Conservation Mode**:
  - Located at `/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode`.
  - When enabled, charging is halted at 60%.
  - This prevents high-voltage battery wear and cell swelling when gaming plugged into the AC charger for extended periods.
  - AeroGaming OS provides a one-click toggle in the **Lenovo Gaming Control Center**.

