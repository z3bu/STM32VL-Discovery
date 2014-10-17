#!/bin/sh

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
