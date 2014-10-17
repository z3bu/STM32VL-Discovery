TARGET:=Demo
TOOLCHAIN_PATH:=/usr/bin
TOOLCHAIN_PREFIX:=arm-none-eabi

CC=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gcc
OBJCOPY=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-objcopy
AS=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-as
AR=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-ar
GDB=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-gdb
SIZE=$(TOOLCHAIN_PATH)/$(TOOLCHAIN_PREFIX)-size

OPTLVL:=1 # Optimization level, can be [0, 1, 2, 3, s].

PROJECT_NAME:=$(notdir $(lastword $(CURDIR)))
STMLIB:=$(CURDIR)/stm32lib
CORE:=$(CURDIR)/cmsis
DEVICE:=$(CURDIR)/device
STARTUP:=$(CURDIR)/device/startup
LINKER_SCRIPT:=$(CURDIR)/device/linker/STM32F100RB_FLASH.ld

INCLUDE=-I"$(CORE)"
INCLUDE+=-I"$(DEVICE)"
INCLUDE+=-I"$(CURDIR)/inc"
INCLUDE+=-I"$(STMLIB)/inc"


# vpath is used so object files are written to the current directory instead
# of the same directory as their source files
vpath %.c $(CURDIR)/src $(STMLIB)/src $(CORE) $(DEVICE)
vpath %.s $(STARTUP)

# Project Source Files
SRC=main.c
#SRC+=stm32f10x_it.c

ASRC=startup_stm32f10x_md_vl.s

#CMSIS core and device
CMSIS=core_cm3.c
CMSIS+=system_stm32f10x.c

#Standard Peripheral Source Files
STM32LIB=stm32f10x_gpio.c
STM32LIB+=stm32f10x_rcc.c
#STM32LIB+=stm32f10x_pwr.c
#STM32LIB+=misc.c
#STM32LIB+=stm32f10x_exti.c

ASFLAGS=-mcpu=cortex-m3 -gdwarf-2

#see stm32lib/inc/stm32f10x.h
CDEFS=-DSTM32F10X_MD_VL
CDEFS+=-DUSE_STDPERIPH_DRIVER

MCUFLAGS= -c -mcpu=cortex-m3 -mthumb -msoft-float -gdwarf-2 -mno-sched-prolog -fno-hosted -mtune=cortex-m3\
		-march=armv7-m -mfix-cortex-m3-ldrd
COMMONFLAGS=-O$(OPTLVL) -g -Wall -Werror 
CFLAGS=$(COMMONFLAGS) $(MCUFLAGS) $(CDEFS)

LDLIBS=
LDFLAGS=$(COMMONFLAGS) -fno-exceptions -ffunction-sections -fdata-sections \
        -nostartfiles -Wl,--gc-sections,-T$(LINKER_SCRIPT)

OBJ = $(CMSIS:%.c=%.o) $(STM32LIB:%.c=%.o) $(SRC:%.c=%.o) $(ASRC:%.s=%.o)

all: ccore cstm32lib casrc csrc ldall
	$(OBJCOPY) -O ihex   $(TARGET).elf $(TARGET).hex
	$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin
	$(SIZE) -B $(TARGET).hex

ccore: $(CMSIS)
	$(CC) $(CFLAGS) $(INCLUDE) $^

cstm32lib: $(STM32LIB)
	$(CC) $(CFLAGS) $(INCLUDE) $^

csrc: $(SRC)
	$(CC) $(CFLAGS) $(INCLUDE) $^
	
casrc: $(ASRC)
	$(AS) $(ASFLAGS) $(INCLUDE) $^ -o $(ASRC:%.s=%.o)

ldall: $(OBJ)
	$(CC) -o $(TARGET).elf $(LDFLAGS) $(LDLIBS) $^ 

#################

.PHONY: clean load

clean:
	rm -f $(OBJ)
	rm -f $(TARGET).elf
	rm -f $(TARGET).hex
	rm -f $(TARGET).bin

load: $(TARGET).bin
	./flashing_stm32vldiscovery.sh $^




