#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/bootdevice/by-name/recovery:15204352:9869abe8ae4dac74bc1ce6a79a776e84fc1414ec; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/block/bootdevice/by-name/boot:14565376:4ea314c68b4166ec1b727c6f041bea92c84ff3c8 EMMC:/dev/block/bootdevice/by-name/recovery 9869abe8ae4dac74bc1ce6a79a776e84fc1414ec 15204352 4ea314c68b4166ec1b727c6f041bea92c84ff3c8:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
