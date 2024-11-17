#!/bin/sh
export HOME=/root
export PATH=$PATH:/sbin

# mount /dev/ /proc /sys
mount -t devtmpfs devtmpfs /dev
mount -t proc none /proc
mount -t sysfs none /sys

echo
echo $(uname -a)
echo

# dhcp
ifconfig eth0 up
sdhcp
echo

# mount input
mkdir -pv /mnt/input
mount -t 9p -o trans=virtio host0 /mnt/input

# mount output
mkdir -pv /mnt/output
mount -t 9p -o trans=virtio host1 /mnt/output

# 1st boot, install packages and write cpio
# 2nd+ boot, start shell
if [ -f "/etc/firstboot.sh" ]; then
    /etc/firstboot.sh
    rm -f /etc/firstboot.sh
else
    if [ -f "/mnt/input/run.sh" ]; then
        /mnt/input/run.sh
    else
        # we are not creating a cpio, and no run.sh,  just boot to sh
        # check term interactive
        if [ -t 0 ]; then
            cd
            /bin/sh
        fi
    fi
    
fi

/carl-exit
