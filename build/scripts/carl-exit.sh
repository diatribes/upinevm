#!/bin/bash
cd "${SRCPATH}/carl-exit" || exit
nasm -felf64 carl-exit.asm -o carl-exit.o
ld -z noseparate-code -s -static -nostdlib -o carl-exit carl-exit.o
strip carl-exit

