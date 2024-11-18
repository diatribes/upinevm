#!/bin/sh
. ./config.sh

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -cpu host \
    -enable-kvm \
    -m ${RUNMEM} \
    -device isa-debug-exit,iobase=0x604,iosize=0x04 \
    -kernel "${OUTPUTPATH}"/bzImage-new \
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "notsc" \
    -initrd "${OUTPUTPATH}"/rootfs-new.cpio

