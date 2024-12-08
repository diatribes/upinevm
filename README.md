Scripts that will generate a small kernel+alpine rootfs cpio that can be direct booted with qemu.

* cd upinevm
* vi ./src/packages.conf
* ./bootstrap.sh
* ./qrun.sh

Generate a new rootfs-new.cpio:
* rm ./build/output/rootfs-new.cpio
* ./bootstrap.sh

```sh
./build.sh fossil
# vm kernel menuconfig and boot scripts
./scripts/menuconfig.sh fossil
./scripts/boot.sh fossil
# or from make
VMNAME=fossil make menuconfig
VMNAME=fossil make boot
```
