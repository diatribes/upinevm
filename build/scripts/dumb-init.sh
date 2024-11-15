#!/bin/bash
cd "${SRCPATH}/dumb-init"
musl-gcc --static -o dumb-init -O2 dumb-init.c
