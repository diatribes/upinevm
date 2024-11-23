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
    -kernel "${OUTPUTPATH}"/bzImage\
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "notsc" \
    -initrd "${OUTPUTPATH}"/rootfs.cpio \
    -virtfs local,path=${INPUTPATH},mount_tag=host0,security_model=none,id=host0 \
    -virtfs local,path=${OUTPUTPATH},mount_tag=host1,security_model=none,id=host1

