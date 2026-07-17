SUMMARY = "Custom Device Tree for EBAZ4205"
SECTION = "bsp"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Provide virtual/dtb so the build system recognizes this recipe
PROVIDES = "virtual/dtb"

inherit devicetree

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add your custom dts
SRC_URI += "file://ebaz4205.dts"

# Align workspace directories
COMPATIBLE_MACHINE = "ebaz4205-zynq7"
