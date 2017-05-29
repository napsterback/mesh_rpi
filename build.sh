#!/bin/sh
export CCPREFIX=/home/raspberrypi/tools/arm-bcm2708/arm-bcm2708hardfp-linux-gnueabi/bin/arm-bcm2708hardfp-linux-gnueabi-
export KERNEL_SRC=/home/raspberrypi/mptcp
export MODULES_TEMP=/home/raspberrypi/mptcp/build

#BUILDING YOUR U-BOOT
#inside u-boot path
ARCH=arm CROSS_COMPILE=${CCPREFIX} chrt -i 0 make rpi_2_config
ARCH=arm CROSS_COMPILE=${CCPREFIX} chrt -i 0 make

#create boot.scr content for B+ model
#   mmc dev 0
#   setenv fdtfile bcm2835-rpi-b-plus.dtb
#   setenv bootargs earlyprintk console=tty0 console=ttyAMA0 root=/dev/mmcblk0p2 rootwait
#   fatload mmc 0:1 ${kernel_addr_r} zImage
#   fatload mmc 0:1 ${fdt_addr_r} ${fdtfile}
#   bootz ${kernel_addr_r} - ${fdt_addr_r}


#making boot img
mkimage -A arm -O linux -T script -C none -n boot.scr -d boot.scr boot.scr.uimg
#OUTPUT:
#   Image Name:   boot.scr
#   Created:      Mon May 29 11:47:51 2017
#   Image Type:   ARM Linux Script (uncompressed)
#   Data Size:    262 Bytes = 0.26 kB = 0.00 MB
#   Load Address: 00000000
#   Entry Point:  00000000
#   Contents:
#       Image 0: 254 Bytes = 0.25 kB = 0.00 MB


#BUILDING LINUX KERNEL FOR B+
ARCH=arm CROSS_COMPILE=${CCPREFIX} make bcm2835_defconfig
ARCH=arm CROSS_COMPILE=${CCPREFIX} chrt -i 0 make



#PUTTING ALL TOGETHER
#   export SD=/media/boot
#   mkdir $SD/backup
#   mv $SD/* $SD/backup
#   cd /usr/src
#   cp u-boot/u-boot.bin media/boot/kernel.img
#   cp linux/arch/arm/boot/zImage $SD
#   cp linux/arch/arm/boot/dts/bcm2835-rpi-b-plus.dtb $SD
#   cp u-boot/tools/boot.scr.uimg $SD
