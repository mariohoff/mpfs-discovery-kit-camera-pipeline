#!/bin/bash

set -x

dtc -I dts -O dtb -o vdma.dtbo vdma.dts
mount -t configfs none /sys/kernel/config
mkdir /sys/kernel/config/device-tree/overlays/vdma
cat /root/vdma.dtbo > /sys/kernel/config/device-tree/overlays/vdma/dtbo
echo 1 > /sys/kernel/config/device-tree/overlays/vdma/status

ls -l /dev/uio*
cat /sys/class/uio/uio*/name
