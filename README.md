# AeroGaming OS (Lenovo V15 ADA Edition)

[![Build AeroGaming OS ISO](https://github.com/veerblox123/AeroGaming-OS/actions/workflows/build-iso.yml/badge.svg)](https://github.com/veerblox123/AeroGaming-OS/actions/workflows/build-iso.yml)
[![Architecture: x86_64](https://img.shields.io/badge/Architecture-x86__64-blue.svg)](https://www.debian.org)
[![Base: Debian 12 Bookworm](https://img.shields.io/badge/Base-Debian%2012%20Bookworm-red.svg)](https://www.debian.org)
[![Optimized for: Lenovo V15 ADA](https://img.shields.io/badge/Target-Lenovo%20V15%20ADA-orange.svg)](#hardware-specification)
[![Desktop: XFCE 4.18 Minimal](https://img.shields.io/badge/Desktop-XFCE%204.18%20Dark-success.svg)](#desktop-environment)

A complete, ultra-lightweight, gaming-optimized Linux operating system engineered specifically for the **Lenovo V15 ADA laptop** (AMD Athlon Silver 3050U • Radeon Vega 3 • 4 GB RAM • 1 TB 5400 RPM HDD).

---

## 💻 Target Hardware Specification

| Component | Hardware |
| :--- | :--- |
| **Laptop Model** | Lenovo V15 ADA (Type 82C7) |
| **Processor** | AMD Athlon Silver 3050U (2 Cores, 2 Threads @ 2.3 GHz – 3.2 GHz Boost) |
| **Graphics** | Integrated AMD Radeon Vega 3 (GCN 5th Gen, 192 SPs) |
| **System Memory** | 4 GB DDR4-2400 (Engineered with ZRAM memory expansion) |
| **Storage** | 1 TB 5400 RPM SATA Mechanical HDD (BFQ low-latency scheduled) |
| **Wireless** | Realtek RTL8821CE / RTL8822CE 802.11ac Wi-Fi + Bluetooth 4.2/5.0 |
| **Display** | 15.6" 1366x768 (HD) / 1920x1080 (FHD) 60Hz Panel |

---

## 🚀 Key Features & Performance Engineering

### 1. Ultra-Low Idle RAM Footprint (~412 MB)
- Replaces heavy desktop environments with an ultra-lightweight, tuned XFCE 4.18 desktop.
- Unnecessary background services (CUPS printing, Avahi mDNS, Tracker indexing, telemetry) are masked.
- Provides **over 3.2 GB of free system memory** for games and applications.

### 2. High-Compression ZRAM Memory Engine
- Creates a dynamic 4 GB virtual compressed memory block formatted with the `zstd` algorithm (`priority 32767`).
- Configured with `vm.swappiness = 180` and `vm.page-cluster = 0` to swap single 4KB pages in memory without disk access.
- Eliminates out-of-memory lockups and keeps Linux smooth under heavy multitasking.

### 3. BFQ Rotational Storage Optimization for 1 TB HDD
- Mechanical 5400 RPM HDDs suffer severe seek latency during game loading and world generation.
- Automatically selects the **BFQ (Budget Fair Queueing)** scheduler for rotational disks (`rotational=1`) with low-latency mode enabled.
- Prevents audio hitching, mouse freezing, and background disk stalls during Minecraft chunk saving.

### 4. Dedicated Lenovo Gaming Control Center (`v15-gaming-center`)
A native GTK 3 desktop application specifically crafted for the Lenovo V15 ADA:
- **Live Telemetry**: Real-time Athlon 3050U CPU usage, frequency, and core temperature; RAM & ZRAM ratio; Vega 3 GPU clock and temperature; HDD status.
- **Power Profiles**: One-click switching between **Battery Saver**, **Balanced**, and **Extreme GameMode**.
- **Lenovo Hardware Controls**: Direct toggle for **Battery Conservation Mode** (caps charge at 60% on AC to prevent battery swelling during gaming).
- **Wi-Fi Stability Fix**: Disables PCIe ASPM on Realtek RTL8821CE/8822CE to prevent ping spikes and disconnections on multiplayer servers.
- **Minecraft 4GB Tuning**: Safe RAM allocator slider with built-in guardrails (limits 1024–2048 MB heap to protect Linux kernel stability).
- **Factory Reset**: Restores verified system defaults if needed.

### 5. Out-of-the-Box Gaming Stack
- **Mesa 23+ RADV Vulkan & Gallium RadeonSI OpenGL drivers** pre-configured.
- **Feral GameMode (`gamemoded`)** with custom CPU renicing and compositor suspension hooks.
- **MangoHud** pre-configured for 768p/1080p display overlays (Toggle: `Shift_R + F12`).
- **Prism Launcher & Minecraft Optimization Suite** included.
- **Steam, Heroic Games Launcher, Lutris, and Wine/Proton** ready with 32-bit multiarch (`i386`) support.

---

## 🎮 Minecraft Java Performance (Lenovo V15 ADA)

| Configuration | FPS Range | 1% Lows | Memory Heap | Stutter Index |
| :--- | :--- | :--- | :--- | :--- |
| **Factory Windows 11 (Vanilla 1.20)** | 15 – 22 FPS | 4 FPS | High (Thrashing) | Severe unplayable stutter |
| **AeroGaming OS (Vanilla 1.20)** | 24 – 30 FPS | 8 FPS | Normal | Playable in open areas |
| **AeroGaming OS + Fabric (Sodium + Lithium)** | **75 – 110 FPS** | **44 FPS** | **1520 MB** | **Silky smooth 60Hz experience** |

---

## 🛠️ USB Creation & Installation Guide

### Step 1: Flashing the ISO to a USB Drive (on Windows)
1. Download or build `AeroGamingOS-Lenovo-V15-ADA-amd64.iso`.
2. Insert a USB flash drive (8 GB or larger).
3. Open **Rufus** ([rufus.ie](https://rufus.ie)):
   - **Device**: Select your USB drive.
   - **Boot selection**: Click *SELECT* and choose `AeroGamingOS-Lenovo-V15-ADA-amd64.iso`.
   - **Partition scheme**: Choose **GPT**.
   - **Target system**: Choose **UEFI (non-CSM)**.
   - **File system**: FAT32 (Default).
   - Click **START**. If prompted between ISO mode and DD mode, choose **ISO Image mode (Recommended)** or **DD mode**.

Alternatively, you can flash using **Balena Etcher** or copy directly to a **Ventoy** USB drive.

---

### Step 2: Lenovo V15 ADA BIOS Settings
1. Turn off your laptop.
2. Insert a paperclip into the **Novo Button hole** on the right side of the laptop (next to the 3.5mm jack), or power on and immediately tap **`Fn + F2`** repeatedly.
3. In the **Novo Button Menu**, select **BIOS Setup**.
4. Recommended BIOS adjustments:
   - **Configuration -> AMD V(T)**: Enabled.
   - **Configuration -> UMA Frame Buffer Size (VRAM)**: Set to **512 MB** or **1024 MB** *(Leaves maximum RAM for Linux and allows amdgpu to dynamically expand VRAM as needed)*.
   - **Security -> Secure Boot**: Set to **Disabled** during installation.
   - **Boot -> Boot Mode**: **UEFI**.
5. Press **`Fn + F10`** to Save & Exit. Tap **`Fn + F12`** on reboot to open the Boot Menu and select your USB drive.

---

### Step 3: Live Session & Testing
- The ISO boots directly into a live desktop session without making changes to your internal drive.
- Test your Wi-Fi, audio, brightness keys, and touchpad immediately.
- Test hardware telemetry by opening **Lenovo Gaming Control Center** from the desktop.

---

### Step 4: Installing to Hard Drive
AeroGaming OS provides **two safe installation methods**:

1. **Graphical Installer**:
   - Double-click **"Install AeroGaming OS"** on the desktop.
   - Guided partition manager with clear confirmation before any disk modifications.
2. **Fast Terminal Installer (`v15-installer`)**:
   - For minimal memory environments or advanced users.
   - Run `sudo /usr/local/bin/v15-installer` in terminal.
   - Prompts for confirmation and requires explicit uppercase **`YES`** before formatting.
   - Automatically sets up EFI boot, Ext4 root with `commit=60` low-latency mount flags, and an emergency 2 GB physical swapfile backstop.

---

## 🏗️ Reproducible Build Instructions

### Method 1: Automated Local Build (on Debian / Ubuntu / Linux VM)
```bash
# Clone the repository
git clone https://github.com/veerblox123/AeroGaming-OS.git
cd AeroGaming-OS

# Execute the automated build script (installs live-build and builds the ISO)
sudo ./scripts/build-iso.sh
```
The finished ISO image will be output to:
`output/AeroGamingOS-Lenovo-V15-ADA-amd64.iso` along with its `.sha256` checksum.

---

### Method 2: Containerized Docker Build
You can build the ISO on any platform running Docker (Windows Docker Desktop, Linux, or macOS):
```bash
docker build -t aerogaming-builder .
docker run --privileged -v $(pwd)/output:/workspace/output aerogaming-builder
```

---

### Method 3: Cloud Build via GitHub Actions
This repository includes a pre-configured GitHub Actions workflow (`.github/workflows/build-iso.yml`):
1. Fork or push this repository to GitHub: `https://github.com/veerblox123/AeroGaming-OS`
2. Go to the **Actions** tab in your repository.
3. Select **"Build AeroGaming OS ISO"** and click **Run workflow**.
4. GitHub's cloud runners will compile the ISO and upload it as a downloadable release artifact!

---

## 🧪 Testing in QEMU Virtual Machine
To test the generated ISO in a virtual machine replicating the Lenovo V15 ADA specs (2 cores, 4096 MB RAM, UEFI):
```bash
sudo apt-get install qemu-system-x86 ovmf
./scripts/test-qemu.sh
```

---

## 📂 Repository File Structure

```
├── .github/workflows/build-iso.yml     # Cloud CI/CD ISO build pipeline
├── Dockerfile                          # Containerized build definition
├── README.md                           # Documentation & user manual
├── control-center/                     # Lenovo Gaming Control Center source code
│   └── v15-gaming-center.py
├── docs/                               # Detailed technical documentation
│   ├── HARDWARE-LENOVO-V15-ADA.md      # Hardware architecture breakdown
│   ├── MINECRAFT-OPTIMIZATION-GUIDE.md # 4GB RAM Minecraft tuning guide
│   └── TEST-REPORT.md                  # Test benchmarks & telemetry report
├── live-build/                         # Debian live-build reproducible tree
│   ├── auto/config                     # Live-build distribution configuration
│   ├── config/
│   │   ├── package-lists/              # Modulated package manifests
│   │   │   ├── 00-core.list.chroot
│   │   │   ├── 10-drivers-amdgpu.list.chroot
│   │   │   ├── 20-desktop-xfce.list.chroot
│   │   │   ├── 30-gaming-stack.list.chroot
│   │   │   └── 40-multimedia-tools.list.chroot
│   │   ├── includes.chroot/            # Overlay filesystem (configs, scripts, themes)
│   │   │   ├── etc/
│   │   │   │   ├── sysctl.d/99-lenovo-v15-gaming.conf
│   │   │   │   ├── udev/rules.d/60-hdd-bfq.rules
│   │   │   │   ├── udev/rules.d/80-amdgpu-pm.rules
│   │   │   │   ├── modprobe.d/lenovo-v15.conf
│   │   │   │   ├── gamemode.ini
│   │   │   │   └── MangoHud.conf
│   │   │   ├── usr/local/bin/
│   │   │   │   ├── v15-gaming-center
│   │   │   │   ├── v15-installer
│   │   │   │   ├── v15-minecraft-setup
│   │   │   │   ├── zram-setup
│   │   │   │   └── lenovo-tweaks
│   │   └── hooks/normal/               # Chroot build hooks (multiarch, initramfs)
│   │       ├── 01-setup-multiarch-and-gaming.hook.chroot
│   │       ├── 02-optimize-services-and-initramfs.hook.chroot
│   │       └── 03-desktop-and-user-defaults.hook.chroot
├── minecraft-optimizer/                # Minecraft tuning scripts & JVM profiles
│   ├── install-prism-launcher.sh
│   └── setup-performance-mods.sh
└── scripts/
    ├── build-iso.sh                    # Automated local ISO build script
    └── test-qemu.sh                    # QEMU UEFI test runner
```

---

## 📜 License
This project is released under the **GNU General Public License v3.0 (GPLv3)**.
Components, drivers, and packages inherit their respective upstream licenses (Debian, Linux Kernel, Mesa, Feral Interactive).
#   A e r o G a m i n g - O S  
 