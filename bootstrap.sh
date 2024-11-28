#!/bin/sh
set -e
# Source config.sh
. ./config.sh

if [ "$1" ]; then
    VMNAME="${1}"
fi

if [ -n "$UPINEVM_CACHEPATH" ]; then
    CACHEPATH="$UPINEVM_CACHEPATH"
fi

: "${CACHEPATH:?CACHEPATH must be set}"

mkdir -pv "${CACHEPATH}"
mkdir -pv "${VMPATH}"
mkdir -pv "${VMPATH}/run/input"
mkdir -pv "${VMPATH}/run/output"

./build/scripts/sdhcp.sh
./build/scripts/dumb-init.sh
./build/scripts/carl-exit.sh
sudo -E ./build/scripts/rootfs.sh

if [ ! -f "${VMPATH}"/bzImage ]; then
    echo "bzImage: not found, building..."
    ./build/scripts/kernel.sh
fi

