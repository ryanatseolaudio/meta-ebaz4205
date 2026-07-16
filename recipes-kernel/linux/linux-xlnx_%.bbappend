FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://ebaz4205.dts"

# This injects your dts directly into the kernel's compile path 
# so it compiles automatically as part of the KERNEL_DEVICETREE variable
do_configure:append() {
    cp ${WORKDIR}/ebaz4205.dts ${STAGING_KERNEL_DIR}/arch/arm/boot/dts/
}
