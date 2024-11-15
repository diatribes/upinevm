Scripts that will generate a small kernel+alpine rootfs cpio that can be direct booted with qemu.

* cd alvm
* vi ./build/input/packages.conf
* ./bootstrap.sh
* ./qrun.sh

Generate a new rootfs-new.cpio:
* rm ./build/output/rootfs-new.cpio
* ./bootstrap.sh
