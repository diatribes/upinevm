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

# 1st boot, install packages and write cpio
# 2nd+ boot, start shell
if [ ! -f "/etc/firstboot" ]; then

    # flag firstboot
	touch /etc/firstboot

    # mount input
    mkdir -pv /mnt/input
    mount -t 9p -o trans=virtio host0 /mnt/input

    # mount output
    mkdir -pv /mnt/output
    mount -t 9p -o trans=virtio host1 /mnt/output

    # update and upgrade
	apk update
	apk upgrade

    # install packages
	apk add `cat /mnt/input/packages.conf`

    # write cpio and exit
	chmod +x /mnt/input/write-cpio.sh
	/mnt/input/write-cpio.sh
else
    # we are not creating a cpio, just boot to sh
	cd
	/bin/sh
fi

/carl-exit
