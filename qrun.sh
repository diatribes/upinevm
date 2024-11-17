#!/bin/sh
source config.sh

sudo /usr/lib/virtiofsd --socket-path=/var/run/qemu-vm-001.sock \
    --shared-dir /tmp/vm-001 --cache always &

sudo chgrp kvm /var/run/qemu-vm-001.sock
sudo chmod g+rxw /var/run/qemu-vm-001.sock

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -cpu host \
    -enable-kvm \
    -m ${RUNMEM} \
    -device isa-debug-exit,iobase=0x604,iosize=0x04 \
    -kernel "${OUTPUTPATH}"/bzImage \
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "notsc" \
    -initrd "${OUTPUTPATH}"/rootfs-new.cpio \
    -virtfs local,path=/tmp/shared,mount_tag=myfs,security_model=none,id=fs0 \
    -device virtio-mmio,addr=0x1000,fsdev=fs0,mount_tag=myfs 

