#!/bin/sh
set -e

export KERNELVER="${KERNELVER:-6.12}"

if [ -z "${VMNAME}" ]; then
    if [ "$1" ]; then
        VMNAME="${1}"
    else
        echo "VMNAME must be set"
        exit 1
    fi
fi
export VMNAME

# Set and export SRCPATH
SRCPATH="${SRCPATH:-$(realpath ./src)}"
export SRCPATH

# TODO: fixme kernel config could match vmname and be found automatically
KERNELCONFIG="${SRCPATH}/kernel-configs/qemu-small-virtiofs-no-tcp"
export KERNELCONFIG

BUILDPATH="${BUILDPATH:-$(realpath -m ./build)}"
export BUILDPATH
VMPATH="${BUILDPATH}/images/${VMNAME}"
export VMPATH
CACHEPATH="${BUILDPATH}/cache/${VMNAME}"
export CACHEPATH

### Create directories

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
        add $(cat "${SRCPATH}"/packages.conf)

    # add custom files
    cd "${SRCPATH}"/overlay
    sudo mkdir -pv "usr/bin"
    sudo cp -v "${CACHEPATH}/sdhcp/sdhcp" "${SRCPATH}/overlay/usr/bin/"
    sudo cp -v "${SRCPATH}/dumb-init/dumb-init" "${SRCPATH}"/overlay/
    sudo cp -v "${SRCPATH}/carl-exit/carl-exit" "${SRCPATH}"/overlay/
    sudo cp -vr "${SRCPATH}/overlay/"* "${CACHEPATH}"/rootfs

    cd "${CACHEPATH}"/rootfs
    sudo -E find . | sudo -E cpio -o -H newc >"${VMPATH}"/rootfs.cpio
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
        cp "${KERNELCONFIG}" .config
        make -j"$(nproc)" && cp arch/x86/boot/bzImage "${VMPATH}"/bzImage
    fi
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
