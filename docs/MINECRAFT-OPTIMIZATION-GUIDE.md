# Minecraft Java Edition Optimization Guide for Lenovo V15 ADA

This guide details how to achieve 60–90+ FPS in Minecraft Java Edition (version 1.20+) on the Lenovo V15 ADA laptop (AMD Athlon Silver 3050U + Radeon Vega 3 + 4GB RAM).

---

## 1. The 4 GB RAM Allocation Formula

On a machine with 4 GB physical RAM:
- ~512 MB to 1024 MB is dynamically reserved by hardware for the integrated AMD Radeon Vega 3 GPU.
- ~400 MB to 500 MB is used by the AeroGaming OS kernel, X11 server, and desktop environment.
- This leaves approximately **2.5 GB to 2.8 GB** of free system memory.

### ⚠️ Common Mistake: Allocating 3 GB or 3.5 GB to Minecraft
Allocating 3 GB or more to the Java heap causes the Linux kernel to run out of memory. This triggers heavy disk swapping or the Out-Of-Memory (OOM) killer, freezing the laptop.

### ✅ The Optimal Configuration: 2048 MB Maximum Heap
- **Minimum Heap (`-Xms`)**: `1024M`
- **Maximum Heap (`-Xmx`)**: `2048M` (2 GB)

This guarantees Minecraft has enough memory to load textures and chunks, while leaving 1.5–2 GB for Java off-heap native memory (LWJGL, Mesa Vulkan/OpenGL buffers) and the operating system.

---

## 2. Low-Latency Garbage Collection Flags (G1GC)

Modern Minecraft 1.20+ runs on Java 17 and Java 21. Standard GC settings cause 200–500ms stutter spikes when collecting dead block entities.

Use these tuned JVM arguments in **Prism Launcher** or the **Minecraft Launcher**:

```bash
-Xms1024M -Xmx2048M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1
```

*(These flags are automatically configured by clicking **"Apply Optimized JVM Arguments"** in the **Lenovo Gaming Control Center**)*.

---

## 3. Essential Fabric Performance Stack

Vanilla Minecraft's OpenGL 2.1 rendering pipeline runs poorly on AMD APUs under Linux (averaging 15–25 FPS). The Fabric mod stack replaces this pipeline with modern vertex shaders and optimized physics algorithms.

| Mod | Function | Athlon 3050U + Vega 3 Impact |
| :--- | :--- | :--- |
| **Sodium** | Complete modern rewrite of block rendering | **+150% to +300% FPS boost** (from 22 FPS to 75-100 FPS) |
| **Lithium** | Replaces physics, AI, and chunk ticking | **Cuts CPU thread usage by up to 40%** on 2C/2T Athlon 3050U |
| **FerriteCore** | Memory compaction and string deduplication | **Reduces Java RAM consumption by 30-40%** |
| **ImmediatelyFast** | Optimizes HUD, text rendering, and entity labels | Eliminates inventory menu frame drops |
| **Entity Culling** | Skips rendering entities behind solid walls | Boosts FPS around large mob farms and villages |

---

## 4. Recommended In-Game Video Settings

Inside Minecraft (with Sodium installed), navigate to **Options -> Video Settings**:

- **Resolution**: `1366x768` (native panel resolution for HD model) or `1600x900` / `1920x1080` (FHD model).
- **Fullscreen**: **Enabled** *(allows AeroGaming OS to unredirect the display buffer directly to the Vega 3 GPU for zero input lag)*.
- **Render Distance**: **8 to 10 Chunks** *(Do not use 16+ on 4GB RAM + 5400 RPM HDD)*.
- **Simulation Distance**: **6 Chunks**.
- **Graphics**: Fast.
- **Clouds**: Fast or Off.
- **Particles**: Decreased.
- **Smooth Lighting**: Off or Low.
- **VSync**: Off in-game *(system compositor handles refresh cleanly)*.
- **Max Framerate**: `60 FPS` or `Unlimited`.

---

## 5. MangoHud In-Game Monitoring

To display real-time FPS, CPU temperature, Vega GPU clock, and RAM usage while playing:
- Press **`Shift_R + F12`** (Right Shift + F12) to toggle MangoHud overlay.
- MangoHud uses less than 0.2% CPU overhead and zero memory impact.

