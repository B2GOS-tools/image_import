#!/bin/bash

# Test if tmp/ exists already and delete it if yes.
if [ -d "tmp" ] ; then
  echo "tmp folder exists. So remove it."
  rm -rf tmp
fi
mkdir tmp

# Test if out/ exists already and delete it if yes.
if [ -d "out" ] ; then
  echo "out folder exists. So remove it."
  rm -rf out
fi
mkdir out

chmod -R 777 out tmp

# Open boot.img and check if it us user build
echo "Hacking boot.img"
BOOT_IMAGE_CREATE=`./bin/unmkbootimg -i boot.img`
mv kernel ramdisk.cpio.gz tmp/
cd tmp/
mkdir ramdisk
cd ramdisk
gunzip -c ../ramdisk.cpio.gz | cpio -i

cd ../../
# Open system.img and check if it is user build
echo "Hacking system.img"
LD_LIBRARY_PATH=./lib/out_host_linux-x86_lib64 ./bin/simg2img system.img tmp/system.raw
cd tmp/ && mkdir system && mount -t ext4 -o loop system.raw system/




