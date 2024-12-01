#!/bin/bash

cd "${CACHEPATH}" || exit 1
ls -la "${CACHEPATH}"

# get apk.static tool
curl -o "${CACHEPATH}/apk.static" https://gitlab.alpinelinux.org/api/v4/projects/5/packages/generic/v2.14.0/x86_64/apk.static || exit 1
chmod +x "${CACHEPATH}/apk.static"

# init rootfs
mkdir -p "${CACHEPATH}/rootfs"

# my shellcheck wants package list in quotes. xargs is used to remove them

./apk.static --arch x86_64 \
    -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/ \
    -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/community/ \
    -U --allow-untrusted \
    --root ./rootfs --initdb \
    add < "${SRCPATH}/packages.conf" || exit 1


# add custom files
mkdir -p "${SRCPATH}/overlay/usr/bin"
cp -v "${CACHEPATH}/sdhcp/sdhcp" "${SRCPATH}/overlay/usr/bin/sdhcp"
cp -v "${SRCPATH}/dumb-init/dumb-init" "${SRCPATH}/overlay"
cp -v "${SRCPATH}/carl-exit/carl-exit" "${SRCPATH}/overlay"
cp -r "${SRCPATH}/overlay/*" "${CACHEPATH}/rootfs"

cd "${CACHEPATH}/rootfs" || exit
find . | cpio -o -H newc > "${VMPATH}/rootfs.cpio"

