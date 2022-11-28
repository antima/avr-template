# Template for AVR projects

This repository contains a template that can be used to set up a C project for an AVR microcontroller.

## Before you start

You can either use GNU Make with the provided Makefile, or CMake with the provided CMakeLists.txt file.
Either way, before using any of the two, you have to define some variables within the chosen file:

- **MCU**, the MCU in the AVR part format specified by avrdude, a complete list can be accessed through the 
```avrdude -p ?``` command
- **CLOCK_FREQ**, the clock frequency at which the MCU is configured tho run at; the default can be inferred by the MCU 
datasheet together with the fuse configuration.
- **PROJ_NAME**, the name of the project, and of the generated executables.
- **PROG_STR**, defaults to atmelice (ATMEL ICE in JTAG mode), and should contain the programmer identifier in the 
avrdude format; a complete list can be accessed through the ```avrdude -c ?``` command

## Using GNU make

```bash
make              # Builds in debug mode
make release      # Builds in release mode
make clean        # Cleans the object files and the final executables

make flash        # flashes the generated hex file
make flash-debug  # flashes the generated elf file 
```

## Using CMake

```bash
mkdir build && cd build
cmake .. -B . # Defaults to a debug build
cmake .. -B . -DCMAKE_BUILD_TYPE=Release # If you want a release build
```

The same rules are available here too, except for the release one, whichever build tool you use (tested with ninja, make).
