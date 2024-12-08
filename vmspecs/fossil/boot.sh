#!/bin/sh

# Set default values for INPUT_DIR and OUTPUT_DIR
INPUT_DIR="${INPUT_DIR:-./input}"
OUTPUT_DIR="${OUTPUT_DIR:-./output}"

# Override with command line arguments if provided
if [ -n "$1" ]; then
    INPUT_DIR="$1"
fi

if [ -n "$2" ]; then
    OUTPUT_DIR="$2"
fi

if [ ! -d "$INPUT_DIR" ]; then
    echo "Input directory does not exist, creating: $INPUT_DIR"
    mkdir -pv "$INPUT_DIR"
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Output directory does not exist, creating: $OUTPUT_DIR"
    mkdir -pv "$OUTPUT_DIR"
fi

qemu-system-x86_64 \
    -display none \
    -no-reboot \
    -no-user-config \
    -nodefaults \
    -cpu host \
    -enable-kvm \
    -m 512 \
    -device isa-debug-exit,iobase=0x604,iosize=0x04 \
    -kernel ./bzImage \
    -nographic \
    -serial none -device isa-serial,chardev=s1 \
    -chardev stdio,id=s1,signal=off \
    -append "notsc" \
    -initrd ./rootfs.cpio \
    -virtfs local,path="$INPUT_DIR",mount_tag=host0,security_model=none,id=host0 \
    -virtfs local,path="$OUTPUT_DIR",mount_tag=host1,security_model=none,id=host1