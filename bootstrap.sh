#!/bin/sh
set -e
# Source config.sh
. ./config.sh

if [ "$1" ]; then
    export VMNAME="${1}"
fi

if [ -n "$UPINEVM_CACHEPATH" ]; then
    CACHEPATH="$UPINEVM_CACHEPATH"
fi

: "${CACHEPATH:?CACHEPATH must be set}"

mkdir -pv "${CACHEPATH}"
mkdir -pv "${VMPATH}"
mkdir -pv "${VMPATH}/run/input"
mkdir -pv "${VMPATH}/run/output"

./build/scripts/sdhcp.sh || exit 1
./build/scripts/dumb-init.sh || exit 1
./build/scripts/carl-exit.sh || exit 1
sudo -E ./build/scripts/rootfs.sh || exit 1

if [ ! -f "${VMPATH}"/bzImage ]; then
    echo "bzImage: not found, building..."
    ./build/scripts/kernel.sh
fi

