BIN=stm32vldiscovery

TOOLS_PATH=/usr
TOOLS_PREFIX=arm-none-eabi
TOOLS_VERSION=4.8.4

OPTLVL:=0 # Optimization level, can be [0, 1, 2, 3, s].

CFLAGS=-c -mcpu=cortex-m3 -mthumb -Wall -O$(OPTLVL) -mapcs-frame -D__thumb2__=1 
CFLAGS+=-msoft-float -gdwarf-2 -mno-sched-prolog -fno-hosted -mtune=cortex-m3 
CFLAGS+=-march=armv7-m -mfix-cortex-m3-ldrd -ffunction-sections -fdata-sections 
CFLAGS+=-I./cmsis -I./stm32_lib -I.
ASFLAGS=-mcpu=cortex-m3 -I./cmsis -I./stm32_lib -gdwarf-2 -gdwarf-2
LDFLAGS=--specs=nosys.specs
LDFLAGS+=-static -mcpu=cortex-m3 -mthumb -mthumb-interwork -Wl,--start-group 
LDFLAGS+=-L$(TOOLS_PATH)/lib/gcc/arm-none-eabi/$(TOOLS_VERSION)/thumb 
LDFLAGS+=-L$(TOOLS_PATH)/arm-none-eabi/lib/thumb -lc -lg -lstdc++ -lsupc++ -lgcc -lm 
#LDFLAGS+=--section-start=.text=0x8000000
LDFLAGS+=-Wl,--end-group -Xlinker -Map -Xlinker $(BIN).map -Xlinker 
LDFLAGS+=-T ./stm32_lib/device_support/gcc/stm32f100rb_flash.ld -o $(BIN).elf

CC=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)-gcc-$(TOOLS_VERSION)
AS=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)-as
SIZE=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)-size
OBJCOPY=$(TOOLS_PATH)/bin/$(TOOLS_PREFIX)-objcopy

# vpath is used so object files are written to the current directory instead
# of the same directory as their source files
#vpath %.c $(CURDIR)/src $(STD_PERIPH)/src $(DEVICE) $(CORE) $(DISCOVERY) 
#vpath %.s $(STARTUP)

#INC_PATH=./inc
# -I"$(INC_PATH)"
SRC_PATH=stm32_lib
#./src

CMSISSRC=./cmsis/core_cm3.c
STM32_LIBSRC=$(SRC_PATH)/system_stm32f10x.c
STM32_LIBSRC+=$(SRC_PATH)/stm32f10x_it.c
STM32_LIBSRC+=$(SRC_PATH)/stm32f10x_rcc.c
STM32_LIBSRC+=$(SRC_PATH)/stm32f10x_gpio.c

SRC=main.c

OBJ=core_cm3.o system_stm32f10x.o stm32f10x_it.o startup_stm32f10x_md_vl.o
OBJ+=stm32f10x_rcc.o stm32f10x_gpio.o
OBJ+=main.o

all: ccmsis cstm32_lib cc ldall
	$(SIZE) -B $(BIN).elf

ccmsis: $(CMSISSRC)
	$(CC) $(CFLAGS) $(CMSISSRC)

cstm32_lib: $(STM32_LIBSRC)
	$(CC) $(CFLAGS) $(STM32_LIBSRC)
	$(AS) $(ASFLAGS) ./stm32_lib/device_support/gcc/startup_stm32f10x_md_vl.S -o startup_stm32f10x_md_vl.o

cc: $(SRC)
	$(CC) $(CFLAGS) $(SRC)

ldall:
	$(CC) $(OBJ) $(LDFLAGS)

.PHONY: clean load

clean:
	rm -f 	$(OBJ) \
		$(BIN).map \
		$(BIN).bin \
		$(BIN).elf

load: $(BIN).elf
	$(OBJCOPY) -O binary $(BIN).elf $(BIN).bin
	./flashing_stm32vldiscovery.sh $(BIN).bin

#debug:
