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

# mount input
mkdir -pv /mnt/input
mount -t 9p -o trans=virtio host0 /mnt/input

# mount output
mkdir -pv /mnt/output
mount -t 9p -o trans=virtio host1 /mnt/output

if [ -f "/mnt/input/run.sh" ]; then
    chmod +x /mnt/input/run.sh
    /mnt/input/run.sh
else
    # no run.sh, just boot to sh, if term interactive
    if [ -t 0 ]; then
        cd
        /bin/sh
    else
        echo "no interactive term"
    fi
fi
    

echo "carl signing off"
/carl-exit
