#!/bin/sh
set -e

# this script is in upinevm, and in built images it is filtered out in write-cpio.sh

if [ -f /mnt/input/write-cpio.sh ]; then
    # update and upgrade
    apk upgrade --no-cache

    # install packages
    apk add --no-cache `cat /mnt/input/packages.conf`

    # write cpio and exit
    chmod +x /mnt/input/write-cpio.sh
    /mnt/input/write-cpio.sh
else
    echo "firstboot: no write-cpio.sh, exiting"
    find / ! -path "/mnt/*" ! -path "/sys/*" ! -path "/proc/*" ! -path "/dev/*" ! -path "/etc/firstboot" ! -path "/etc/firstboot.sh"
    find / -name firstboot
    find / -name firstboot.sh
    echo "this case is an error"
    exit 1
fi
