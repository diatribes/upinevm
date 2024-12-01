#!/bin/bash
cd "${SRCPATH}/dumb-init" || exit
musl-gcc --static -o dumb-init -O2 dumb-init.c
