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

if [ ! -d "${VMPATH}" ]; then
    echo "VMPATH directory does not exist: ${VMPATH}"
    echo "Please run ./build.sh ${VMNAME} to create the vm directory"
    exit 1
fi

cd "${VMPATH}" || exit 1
./boot.sh

