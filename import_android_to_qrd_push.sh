
#!/bin/bash

cd tmp/ramdisk
# Create a new ramdisk based on the changes
find . | cpio -o -H newc | gzip > ../ramdisk.cpio.gz
cd ../
#BOOT_IMAGE_CREATE=${BOOT_IMAGE_CREATE#*:}
#BOOT_IMAGE_CREATE=${BOOT_IMAGE_CREATE/"boot.img"/"../out/boot_hack.img"}
#$BOOT_IMAGE_CREATE
echo "Creating a hacked boot.img"
../bin/mkbootimg --base 0 --pagesize 2048 --kernel_offset 0x80008000 --ramdisk_offset 0x81000000 --second_offset 0x80f00000 --tags_offset 0x80000100 --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk androidboot.selinux=permissive' --kernel kernel --ramdisk ramdisk.cpio.gz -o ../out/boot_hack.img
if [ "$?" -ne "0" ] ; then
  echo "Fail to create a hacked boot.img"
  exit 0
else
  echo "Done."
fi
cd ../


# Create a hacked system.img
echo "Creating hacked system.img"
LD_LIBRARY_PATH=./lib/out_host_linux-x86_lib64 ./bin/make_ext4fs -s -T -1 -S tmp/ramdisk/file_contexts -L system -l 838860800 -a system out/system_hack.img tmp/system/ 2>&1 /dev/null
echo "Done."

# Flash hacked boot.img and system.img
echo "Update hacked boot.img and system.img to device and then reboot..."
FASTBOOT_AVAILABLE=`./bin/fastboot devices`
if [ "$FASTBOOT_AVAILABLE" == "" ] ; then
  echo "Device is not in fastboot mode!!!"
  exit 0
fi
./bin/fastboot flash boot out/boot_hack.img
./bin/fastboot flash system out/system_hack.img
./bin/fastboot reboot