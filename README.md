---

# Yocto Board Support Package (BSP) for EBAZ4205

This repository contains the Yocto/OpenEmbedded BSP layer and build configuration for the **EBAZ4205 Zynq-7000 Development Board**.

The EBAZ4205 is a highly cost-effective, surplus mining control board featuring a Xilinx Zynq-7000 SoC (XC7Z010). This layer provides configurations to bootstrap Linux on the board, restricting physical memory to its onboard **256MB DDR3 RAM** and setting up boot definitions for SD card setups.

---

## 🛠 Features Included

* **Target Machine:** `ebaz4205-zynq7` (Cortex-A9 Zynq-7000)
* **Memory Optimization:** Restricts memory footprint to physical **256MB DDR3** boundary via U-Boot/Kernel patches.
* **Modern Boot Chain:** Generates a unified `BOOT.bin` using Xilinx FSBL.
* **Custom Device Tree:** Standalone `device-tree` recipe compiling custom board DTS targeting 256MB DDR configurations.
* **Declarative Builds:** Fully managed via `kas` for reproducible, containerized compilation using Yocto Scarthgap / 2026.1 releases.

---

## 🏗 Repository Structure

```text
.
├── ebaz4205-project.yml                   # Kas configuration file (main build entrypoint)
└── meta-ebaz4205/                         # Repository root
    └── meta-ebaz4205/                     # Custom Yocto Layer
        ├── conf/
        │   ├── layer.conf
        │   └── machine/
        │       └── ebaz4205-zynq7.conf    # Machine configuration file
        ├── recipes-bsp/
        │   ├── device-tree/
        │   │   ├── device-tree.bb         # Standalone Device Tree recipe
        │   │   └── files/
        │   │       └── ebaz4205.dts       # Board Device Tree Source
        │   └── u-boot/
        │       └── u-boot-xlnx_%.bbappend # U-Boot build customization
        └── recipes-kernel/
            └── linux/
                └── linux-xlnx_%.bbappend  # Placeholder
```

---

## 🚀 Quick Start (Building with Kas)

This project uses **Kas** to manage layers and automate containerized builds. You do not need to manually clone Poky or dependency layers.

### Prerequisites

Make sure you have Docker or Podman installed and the `kas-container` script downloaded:

```bash
wget https://raw.githubusercontent.com/siemens/kas/master/kas-container
chmod +x kas-container

```

### Run the Build

Kick off the build process by pointing `kas-container` at the project configuration file:

```bash
./kas-container build ebaz4205-project.yml

```

---

## 💾 Flashing to SD Card

Once compilation completes, the build artifacts will be deployed inside:
`build/tmp-glibc/deploy/images/ebaz4205-zynq7/`

### 1. Partition Your SD Card

Format your MicroSD card with two partitions:

* **Partition 1:** FAT32 (at least 50MB, flagged as bootable).
* **Partition 2:** ext4 (for the root filesystem).

### 2. Copy Boot Files (FAT32 Partition)

Copy the essential boot binaries to the first partition:

```bash
cp build/tmp-glibc/deploy/images/ebaz4205-zynq7/BOOT.bin /media/$USER/BOOT/
cp build/tmp-glibc/deploy/images/ebaz4205-zynq7/uImage /media/$USER/BOOT/
cp build/tmp-glibc/deploy/images/ebaz4205-zynq7/devicetree.dtb /media/$USER/BOOT/

```

### 3. Extract the RootFS (ext4 Partition)

Extract your compiled root filesystem archive directly to the second partition:

```bash
sudo tar -xf build/tmp-glibc/deploy/images/ebaz4205-zynq7/core-image-minimal-ebaz4205-zynq7.rootfs.tar.gz -C /media/$USER/ROOTFS/
sync

```

---

## 🔌 Hardware Setup (Booting)

1. Insert the prepared MicroSD card into your hardware card slot.
2. Connect a USB-to-UART converter to the EBAZ4205 debug serial header (`115200` baud, 8N1).
3. Open your favorite serial terminal (e.g., `minicom`, `screen`, or `picocom`):
```bash
picocom -b 115200 /dev/ttyUSB0

```


4. Power up the board. U-Boot SPL will load U-Boot proper, execute `sdboot`, load the Linux kernel and devicetree, and boot to a root prompt!
