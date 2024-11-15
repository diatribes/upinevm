#!/bin/bash 
cd "${CACHEPATH}"

if [ ! -d "sdhcp" ]; then
    git clone git://git.2f30.org/sdhcp
    cd sdhcp
    make CC=musl-gcc LDFLAGS=--static
    mkdir -vp "${SRCPATH}/overlay/usr/bin"
    cp -v sdhcp "${SRCPATH}/overlay/usr/bin/sdhcp"
    cd ..
fi

