#!/bin/sh
export BUILDROOT="${BUILDROOT:-$(realpath .)}"
export CACHEPATH="${CACHEPATH:-$(realpath ./build/cache)}"
export KERNELVER="${KERNELVER:-6.12}"
export SRCPATH="${SRCPATH:-$(realpath src)}"
export OUTPUTPATH="${OUTPUTPATH:-$(realpath ./build/output)}"
export INPUTPATH="${INPUTPATH:-$(realpath ./build/input)}"
export INSTALLMEM="${INSTALLMEM:-512M}"
export RUNMEM="${RUNMEM:-512M}"
export KERNELCONFIG="${KERNELCONFIG:-$(realpath ./src/qemu-kernel-config)}"#!/bin/sh

