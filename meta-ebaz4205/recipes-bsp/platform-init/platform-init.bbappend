FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# 1. Force the make argument to use the built-in microzed DTB
EXTRA_OEMAKE:append = " DEVICE_TREE=zynq-microzed"

# 2. Tell the build system that U-Boot already has its own ps7_init files!
# This prevents the recipe from demanding virtual/xilinx-platform-init.
HAS_PLATFORM_INIT:append = " zynq_microzed"
FORCE_PLATFORM_INIT = "0"
