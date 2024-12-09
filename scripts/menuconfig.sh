#!/bin/sh

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
SCRIPTPATH=$(realpath "${SCRIPT_DIR}")
echo "SCRIPTPATH: ${SCRIPTPATH}"

cd "${SCRIPTPATH}/.." || exit 1
echo "PWD: ${PWD}"

if [ "$1" ]; then
    VMNAME="${1}"
fi
export VMNAME

# shellcheck disable=SC1091
. ./config.sh

if [ -z "${CACHEPATH}" ]; then
    echo "CACHEPATH is not set"
    exit 1
fi

if [ ! -d "${CACHEPATH}" ]; then
    echo "CACHEPATH directory does not exist: ${CACHEPATH}"
    echo "Please run ./build.sh ${VMNAME} to create the cache directory"
    exit 1
fi

if [ -z "${KERNELCONFIG}" ]; then
    echo "KERNELCONFIG is not set"
    exit 1
fi

if [ ! -f "${KERNELCONFIG}" ]; then
    echo "KERNELCONFIG file does not exist: ${KERNELCONFIG}"
    exit 1
fi



# open the kernel configuration menu for a vmname in vmspecs
# if no vmname is provided, use the default vmname
# script should set project root to the parent directory of the scripts directory
# and cd to realpath of the vmspecs directory and call make menuconfig with kernel-config
# as the target

if [ ! -d "${SPECSPATH}" ]; then
    echo "VM spec directory does not exist: ${SPECSPATH}"
    exit 1
fi


if [ ! -d "${SPECSPATH}/${VMNAME}" ]; then
    echo "VM spec directory does not exist: ${SPECSPATH}/${VMNAME}"
    exit 1
fi

cd "${CACHEPATH}"/linux-"${KERNELVER}" || exit 1

echo "VM spec directory: ${SPECSPATH}/${VMNAME}"
echo "VMSPEC: ${VMSPEC}"
echo "KERNELCONFIG: ${KERNELCONFIG}"
echo "CACHEPATH: ${CACHEPATH}"
echo "PWD: ${PWD}"

KCONFIG_CONFIG=${KERNELCONFIG} make menuconfig
