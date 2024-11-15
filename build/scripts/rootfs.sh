#!/bin/bash 
curl -o "${CACHEPATH}/alpine-rootfs.tar.gz" "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-minirootfs-3.20.3-x86_64.tar.gz"
cd "${CACHEPATH}"
mkdir -p rootfs
cd rootfs
tar xvf ../alpine-rootfs.tar.gz
cp -v "${SRCPATH}/dumb-init/dumb-init" "${SRCPATH}/overlay"
cp -v "${SRCPATH}/carl-exit/carl-exit" "${SRCPATH}/overlay"
cp -r ${SRCPATH}/overlay/* .
chmod +x dumb-init
chmod +x carl-exit
find . | cpio -o -H newc > "${OUTPUTPATH}"/rootfs.cpio

