#!/bin/sh
export VMNAME="gccvm"
export VMPATH="${VMPATH:-$(realpath -m ./images/${VMNAME})}"
export KERNELVER="${KERNELVER:-6.12}"
export KERNELCONFIG="${KERNELCONFIG:-$(realpath ./src/kernel-configs/qemu-small-virtiofs-no-tcp)}"
export CACHEPATH="${CACHEPATH:-$(realpath -m ./build/cache/${VMNAME})}"
export SRCPATH="${SRCPATH:-$(realpath ./src)}"

