#!/bin/sh
export CACHEPATH=`realpath ./build/cache`
export KERNELVER=6.11.7
export SRCPATH=`realpath src`
export OUTPUTPATH=`realpath ./build/output`
export INPUTPATH=`realpath ./build/input`
export INSTALLMEM=512M
export RUNMEM=512M
export KERNELBOOTSTRAPCONFIG=`realpath ./src/qemu-bootstrap-kernel-config`
export KERNELCONFIG=`realpath ./src/qemu-kernel-config`

