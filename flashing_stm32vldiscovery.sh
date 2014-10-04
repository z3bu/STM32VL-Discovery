#!/bin/sh

# Check - is sg module loaded. If not load it. If error - exit.
#lsmod | grep -q sg
#if [ "$?" -ne "0" ]; then
#    echo "sg module not loaded - loading it..."
#    sudo modprobe sg
#    if [ "$?" -ne "0" ]; then
#	echo "Error loading module sg!"
#	echo "Try to recompile you kernel with \
#option 'CONFIG_CHR_DEV_SG=m'."
#	echo "You may find it in 'Device Drivers' -> \
#'SCSI' drivers"
#	exit 1
#    fi
#fi

#echo "*****************************************************************"
#echo "*  Starting GDB server...                                       *"
#echo "*  For connect to it - run GDB in another console and:          *"
#echo "*   (gdb) target remote :4242                                   *"
#echo "*  For load ELF to STM32VLDiscovery                             *"
#echo "*   (gdb) load $1                                               *"
#echo "* Note: please use arm-none-eabi-gdb unstead of x86 targeted    *"
#echo "* gdb!                                                          *"
#echo "*****************************************************************"
#st-util 4242 /dev/stlinkv1_1

echo "*****************************************************************"
echo "Flashing stm32 vl with st-link version 1"
echo "*****************************************************************"

st-flash write v1 $1 0x8000000
