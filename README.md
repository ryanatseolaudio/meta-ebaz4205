Here is a clean, production-ready `README.md` boilerplate tailored exactly to your EBAZ4205 Yocto project. It reflects the architecture we've built, the `kas` build system, and the bare-metal / kernel configurations.

---

# Yocto Board Support Package (BSP) for EBAZ4205

This repository contains the Yocto/OpenEmbedded BSP layer and build configuration for the **EBAZ4205 Zynq-7000 Development Board**.

The EBAZ4205 is a highly cost-effective, surplus mining control board featuring a Xilinx Zynq-7000 SoC (XC7Z010). This layer provides configurations to bootstrap Linux on the board, restricting physical memory to its onboard **256MB DDR3 RAM** and setting up boot definitions for SD card setups.

---

## 🛠 Features Included

* **Target Machine:** `ebaz4205-zynq7` (Cortex-A9 Zynq-7000)
* **Memory Optimization:** Restricts memory footprint to physical **256MB DDR3** boundary via U-Boot/Kernel patches to prevent memory-wrap crashes.
* **Boot Chain:** Generates a complete, bootable `BOOT.bin` containing:
* First Stage Bootloader (FSBL)
* U-Boot Bootloader configured with custom boot hooks for automated SD Card loading.


* **Declarative Builds:** Fully managed via `kas` for reproducible, containerized compilation.

---

## 🏗 Repository Structure

```text
.
├── ebaz4205-project.yml          # Kas configuration file (main build entrypoint)
└── meta-ebaz4205/                # Custom Yocto Layer for EBAZ4205
    ├── conf/
    │   ├── layer.conf
    │   └── machine/
    │       └── ebaz4205-zynq7.conf  # Machine configuration file
    ├── recipes-bsp/
    │   └── u-boot/
    │       ├── files/
    │       │   └── 0001-ebaz4205-board-config.patch  # SD Boot & Memory Limit patch
    │       └── u-boot-xlnx_%.bbappend
    ├── recipes-kernel/
    │   └── linux/
    │       ├── files/
    │       │   └── ebaz4205.dts      # Custom Board Device Tree (DTS)
    │       └── linux-xlnx_%.bbappend
    └── recipes-core/
        └── images/
            └── core-image-minimal.bbappend

```

---

## 🚀 Quick Start (Building with Kas)

This project uses **Kas** to manage layers and automate containerized builds. You do not need to manually clone Poky or dependency layers.

### Prerequisites

Make sure you have Docker/Podman installed and the `kas-container` tool downloaded:

```bash
wget https://raw.githubusercontent.com/siemens/kas/master/kas-container
chmod +x kas-container

```

### Run the Build

Kick off the build process by pointing the runner at our project configuration file:

```bash
./kas-container build ebaz4205-project.yml

```

---

## 💾 Flashing to SD Card

Once compilation completes, the build artifacts will be deployed inside:
`build/tmp/deploy/images/ebaz4205-zynq7/`

### 1. Partition Your SD Card

Format your SD card with two partitions:

* **Partition 1:** FAT32 (at least 50MB, flagged as bootable).
* **Partition 2:** ext4 (for the root filesystem).

### 2. Copy Boot Files (FAT32 Partition)

Copy the essential boot binaries to the first partition:

```bash
cp build/tmp/deploy/images/ebaz4205-zynq7/BOOT.bin /media/user/BOOT/
cp build/tmp/deploy/images/ebaz4205-zynq7/uImage /media/user/BOOT/
cp build/tmp/deploy/images/ebaz4205-zynq7/ebaz4205.dtb /media/user/BOOT/

```

### 3. Extract the RootFS (ext4 Partition)

Extract your compiled root filesystem archive directly to the second partition:

```bash
sudo tar -xf build/tmp/deploy/images/ebaz4205-zynq7/core-image-minimal-ebaz4205-zynq7.rootfs.tar.gz -C /media/user/ROOTFS/
sync

```

---

## 🔌 Hardware Setup (Booting)

1. Insert the prepared SD card into your card slot mod.
2. Connect a USB-to-UART converter to the EBAZ4205 debug port (typically J8/J7 depending on your exact board revision).
3. Open your favorite serial monitor (e.g., `minicom`, `screen`, or `PuTTY` set to **115200 baud, 8N1**).
4. Power up the board. U-Boot will execute, automatically trigger `sdboot`, and bring you to a Linux login shell!
