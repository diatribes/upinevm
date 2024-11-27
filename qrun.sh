#!/bin/sh
. ./config.sh

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -cpu host \
    -enable-kvm \
    -m 512 \
    -device isa-debug-exit,iobase=0x604,iosize=0x04 \
    -kernel "${VMPATH}"/bzImage\
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "notsc" \
    -initrd "${VMPATH}"/rootfs.cpio \
    -virtfs local,path=${1},mount_tag=host0,security_model=none,id=host0 \
    -virtfs local,path=${2},mount_tag=host1,security_model=none,id=host1

