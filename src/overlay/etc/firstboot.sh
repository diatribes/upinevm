#!/bin/sh
set -e

# this script is in upinevm, and in built images it is filtered out in write-cpio.sh

if [ -f /root/bin/write-cpio.sh ]; then
    # update and upgrade
    apk upgrade --no-cache

    # install packages
    apk add --no-cache `cat /mnt/input/packages.conf`

    # write cpio and exit
    chown -R root:root / || true
    chmod +x /root/bin/write-cpio.sh
    /root/bin/write-cpio.sh
else
    echo "firstboot: no /root/bin/write-cpio.sh, exiting"
    find / ! -path "/mnt/*" ! -path "/sys/*" ! -path "/proc/*" ! -path "/dev/*" ! -path "/etc/firstboot" ! -path "/etc/firstboot.sh"
    find / -name firstboot
    find / -name firstboot.sh
    echo "this case is an error"
    exit 1
fi
