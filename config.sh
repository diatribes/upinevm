#!/bin/sh
export BUILDROOT="${BUILDROOT:-$(realpath .)}"
export CACHEPATH="${CACHEPATH:-$(realpath ./build/cache)}"
export KERNELVER="${KERNELVER:-6.12}"
export SRCPATH="${SRCPATH:-$(realpath src)}"
export OUTPUTPATH="${OUTPUTPATH:-$(realpath ./run/output)}"
export INPUTPATH="${INPUTPATH:-$(realpath ./run/input)}"
export INSTALLMEM="${INSTALLMEM:-512M}"
export RUNMEM="${RUNMEM:-512M}"
export KERNELCONFIG="${KERNELCONFIG:-$(realpath ./src/kernel-configs/qemu-small-virtiofs-no-tcp)}"#!/bin/s
