# update and upgrade
apk upgrade --no-cache

# install packages
apk add --no-cache `cat /mnt/input/packages.conf`

# write cpio and exit
chmod +x /mnt/input/write-cpio.sh
/mnt/input/write-cpio.sh
