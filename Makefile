# Source and include
BUILD_DIR=build
SRCS=$(wildcard src/*.c)
OBJS=$(SRCS:%.c=build/%.o)
INC=-I ./inc

# MCU configuration
MCU=              # <-- Set the MCU type
CLOCK_FREQ=       # <-- Set the clock frequency
PROG_STR=atmelice # <-- Set the programmer

# Compiler flags
CFLAGS=-std=c11 -Wall -Wextra -Werror -mmcu=$(MCU) -DF_CPU=$(CLOCK_FREQ)
OPT_FLAGS=-O0 -g -DDEBUG

# Compiler and utility tools
OBJCOPY=avr-objcopy
CC=avr-gcc

# Project configuration
PROJ_NAME=template_project         # <-- Set the project name
PROJ_BLD=$(BUILD_DIR)/$(PROJ_NAME)

# Rules

all: $(PROJ_BLD).elf

$(PROJ_BLD).elf: $(OBJS)
	$(CC) -o $@ $^ $(INC) $(CFLAGS) $(OPT_FLAGS) $(MCU_FLAGS)
	$(OBJCOPY) -j .text -j .data -O ihex $@ $(PROJ_BLD).hex
	$(OBJCOPY) -j .text -j .data -O binary $@ $(PROJ_BLD).bin


build/%.o: %.c
	mkdir -p build/src
	$(CC) -c -o $@ $(INC) $(CFLAGS) $(OPT_FLAGS) $(MCU_FLAGS) $<

release: OPT_FLAGS=-O2 -DNDEBUG
release: $(PROJ_BLD).elf

flash:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD).hex:i

flash-debug:
	avrdude -c $(PROG_STR) -p $(MCU) -U flash:w:$(PROJ_BLD).elf:e

clean:
	rm -rf build

.PHONY = clean, release, flash, flash-debug
