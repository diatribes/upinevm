#!/bin/sh
export BUILDROOT=`realpath .`
export CACHEPATH=`realpath ./build/cache`
export KERNELVER=6.12
export SRCPATH=`realpath src`
export OUTPUTPATH=`realpath ./run/output`
export INPUTPATH=`realpath ./run/input`
export INSTALLMEM=512M
export RUNMEM=512M
export KERNELCONFIG=`realpath ./src/kernel-configs/qemu-small-virtiofs-no-tcp`

