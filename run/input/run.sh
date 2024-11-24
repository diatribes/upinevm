#!/bin/sh
set -e
cd /root
cp /mnt/input/testoutput.c .
gcc testoutput.c -o testoutput
./testoutput 2> /mnt/output/stderr.txt 1> /mnt/output/stdout.txt
sync
