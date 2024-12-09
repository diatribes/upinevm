#!/bin/sh
set -e
export HOME=/root
export PATH="$PATH":/sbin
# mount -t devtmpfs devtmpfs /dev
# mount -t proc none /proc
# mount -t sysfs none /sys
uname -a
ifconfig eth0 up
sdhcp

TREEPATH=/mnt/output/mytree
REPOPATH=/mnt/output/repo.fossil

setup-user user
su - user -c "rm -rf ${REPOPATH}"
su - user -c "fossil init ${REPOPATH}"
su - user -c "rm -rf ${TREEPATH}"
su - user -c "mkdir -p ${TREEPATH}"
su - user -c "cd ${TREEPATH} && fossil open ../repo.fossil"
su - user -c "cd ${TREEPATH} && fossil server"

/carl-exit
