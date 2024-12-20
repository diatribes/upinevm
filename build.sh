#!/bin/sh
set -e

# build script for bootstrapping upinevm
if [ "$1" ]; then
    VMNAME="${1}"
fi
export VMNAME

# shellcheck disable=SC1091
. ./config.sh

create_directories() {
    if [ ! -d "${CACHEPATH}" ]; then
        # also creates BUILD directory
        echo "Cache directory does not exist: ${CACHEPATH}"
        mkdir -pv "${CACHEPATH}"
    fi
    if [ ! -d "${VMPATH}" ]; then
        mkdir -pv "${VMPATH}"
        # mkdir -pv "${VMPATH}/run/input"
        # mkdir -pv "${VMPATH}/run/output"
    fi
}

preflight_checks() {
    if [ ! -d "${SRCPATH}" ]; then
        echo "Source directory does not exist: ${SRCPATH}"
        exit 1
    fi

    if [ ! -d "${CACHEPATH}" ]; then
        echo "Cache directory does not exist: ${CACHEPATH}"
        exit 1
    fi

    if [ ! -d "${VMPATH}" ]; then
        echo "VM image directory does not exist: ${VMPATH}"
        exit 1
    fi

    if [ ! -f "${KERNELCONFIG}" ]; then
        echo "Kernel config file does not exist: ${KERNELCONFIG}"
        exit 1
    fi

    if [ ! -f "${PACKAGESPATH}" ]; then
        echo "Packages file does not exist: ${PACKAGESPATH}"
        exit 1
    fi

    if [ ! -f "${BOOTSCRIPT}" ]; then
        echo "Boot script does not exist: ${BOOTSCRIPT}"
        exit 1
    fi

    if [ -z "${KERNELVER}" ]; then
        echo "Kernel version is not set"
        exit 1
    fi

    # check for required tools
    if ! command -v musl-gcc >/dev/null; then
        echo "musl-gcc not found"
        exit 1
    fi

    if ! command -v nasm >/dev/null; then
        echo "nasm not found"
        exit 1
    fi

    if ! command -v ld >/dev/null; then
        echo "ld not found"
        exit 1
    fi

    if ! command -v strip >/dev/null; then
        echo "strip not found"
        exit 1
    fi

    if ! command -v curl >/dev/null; then
        echo "curl not found"
        exit 1
    fi

    if ! command -v sudo >/dev/null; then
        echo "sudo not found"
        exit 1
    fi

    if ! command -v flex >/dev/null; then
        echo "flex not found"
        exit 1
    fi

    if ! command -v bison >/dev/null; then
        echo "bison not found"
        exit 1
    fi
}

build_sdhcp() {
    cd "${CACHEPATH}"

    if [ ! -f "sdhcp/sdhcp" ]; then
        rm -rf sdhcp
        git clone git://git.2f30.org/sdhcp
        cd sdhcp
        make CC=musl-gcc LDFLAGS=--static
    fi
}

build_dumb_init() {
    cd "${SRCPATH}/dumb-init"
    musl-gcc --static -o dumb-init -O2 dumb-init.c
}

build_carl_exit() {
    cd "${SRCPATH}/carl-exit"
    nasm -felf64 carl-exit.asm -o carl-exit.o
    ld -z noseparate-code -s -static -nostdlib -o carl-exit carl-exit.o
    strip carl-exit
}

build_rootfs() {
    cd "${CACHEPATH}"

    # get apk.static tool
    curl -o "${CACHEPATH}"/apk.static https://gitlab.alpinelinux.org/api/v4/projects/5/packages/generic/v2.14.0/x86_64/apk.static
    chmod +x ./apk.static

    # init rootfs
    mkdir -p "${CACHEPATH}"/rootfs
    sudo -E ./apk.static --arch x86_64 \
        -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/ \
        -X http://dl-cdn.alpinelinux.org/alpine/latest-stable/community/ \
        -U --allow-untrusted \
        --root ./rootfs --initdb \
        add $(cat "${PACKAGESPATH}")

    # add custom files
    cd "${CACHEPATH}"/rootfs
    sudo cp -vr "${SRCPATH}/overlay/"* .
    sudo cp -v "${SRCPATH}/dumb-init/dumb-init" .
    sudo cp -v "${SRCPATH}/carl-exit/carl-exit" .
    sudo mkdir -pv "usr/bin"
    sudo cp -v "${CACHEPATH}/sdhcp/sdhcp" ./usr/bin/

    # shellcheck disable=SC2024
    sudo -E find . | sudo -E cpio -o -H newc >"${VMPATH}"/rootfs.cpio
    sudo rm -rvf "${CACHEPATH}"/rootfs
}

build_kernel() {
    if [ ! -f "${VMPATH}"/bzImage ]; then
        echo "bzImage: not found, building..."
        cd "${CACHEPATH}"
        if [ ! -d "linux-${KERNELVER}" ]; then
            curl -o "linux-${KERNELVER}.tar.xz" "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNELVER}.tar.xz"
            tar xvf "linux-${KERNELVER}.tar.xz"
        fi
        cd "linux-${KERNELVER}"
        cp -v "${KERNELCONFIG}" .config
        make -j"$(nproc)" && cp arch/x86/boot/bzImage "${VMPATH}"/bzImage
    fi
}

build_bootscript() {
    cp -v "${BOOTSCRIPT}" "${VMPATH}"/boot.sh
}

clean() {
    rm -rf "${BUILDPATH}"
}

create_directories
preflight_checks
build_sdhcp
build_dumb_init
build_carl_exit
build_rootfs
build_kernel
build_bootscript
