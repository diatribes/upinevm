#!/bin/bash
cd "${CACHEPATH}" || exit

if [ ! -d "sdhcp" ]; then
    git clone git://git.2f30.org/sdhcp
    cd sdhcp || exit
    make CC=musl-gcc LDFLAGS=--static
    cd ..
fi

