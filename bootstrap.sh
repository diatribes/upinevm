#!/bin/sh
set -e
# Source config.sh
. ./config.sh

# Restore the cached values if they were set
if [ -n "$UPINEVM_OUTPUTPATH" ]; then
    OUTPUTPATH="$UPINEVM_OUTPUTPATH"
fi

: "${OUTPUTPATH:?OUTPUTPATH must be set}"

mkdir -pv "${CACHEPATH}"
mkdir -pv "${OUTPUTPATH}"

./build/scripts/sdhcp.sh
./build/scripts/dumb-init.sh
./build/scripts/carl-exit.sh
./build/scripts/rootfs.sh

export CURRENTKERNELCONFIG=${KERNELBOOTSTRAPCONFIG}
./build/scripts/kernel.sh

# Exit early if UPINEVM_NOLAUNCH is set
if [ -n "$UPINEVM_NOLAUNCH" ]; then
    echo "UPINEVM_NOLAUNCH is set. Exiting script early."
    exit 0
fi

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -m ${INSTALLMEM} \
    -kernel "${OUTPUTPATH}/bzImage" \
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "panic=-1 notsc" \
    -initrd "${OUTPUTPATH}/rootfs.cpio" \
    -nic user,model=virtio-net-pci \
    -virtfs local,path=${INPUTPATH},mount_tag=host0,security_model=none,id=host0 \
    -virtfs local,path=${OUTPUTPATH},mount_tag=host1,security_model=none,id=host1

export CURRENTKERNELCONFIG=${KERNELCONFIG}
./build/scripts/kernel.sh
