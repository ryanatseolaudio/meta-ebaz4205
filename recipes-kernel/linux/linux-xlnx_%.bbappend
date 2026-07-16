FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://ebaz4205.dts"

do_configure:append() {
    # Copy the device tree source into the kernel source tree right before compiling
    cp ${WORKDIR}/ebaz4205.dts ${STAGING_KERNEL_DIR}/arch/arm/boot/dts/
}
