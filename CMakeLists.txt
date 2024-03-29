cmake_minimum_required(VERSION 3.22)
set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_GENERATOR "Unix Makefiles")
project(template_project C) # Set the project name

# Default to Debug build
if (NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE Debug)
endif()

# MCU configuration
# Set MCU type, clock frequency and programmer
set(MCU "")
set(CLOCK_FREQ "")
set(PROG_STR atmelice)


# C compiler flags
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_ASM_COMPILER avr-gcc)
set(GCC_FLAGS "-Wall -Wextra -Werror -DF_CPU=${CLOCK_FREQ} -mmcu=${MCU}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GCC_FLAGS}")

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    add_compile_options(-O0 -g)
else ()
    add_compile_options(-O2)
endif ()


file(GLOB_RECURSE SOURCES
	"src/*.*"
)

add_executable(${PROJECT_NAME}.elf ${SOURCES})

target_include_directories(${PROJECT_NAME}.elf PRIVATE inc)

set_property(TARGET ${PROJECT_NAME}.elf
	APPEND
	PROPERTY ADDITIONAL_CLEAN_FILES ${PROJECT_NAME}.hex ${PROJECT_NAME}.bin
)

add_custom_command(TARGET ${PROJECT_NAME}.elf
	POST_BUILD
	COMMAND avr-objcopy -j .text -j .data -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
	COMMAND avr-objcopy -j .text -j .data -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
)

add_custom_target(flash
	DEPENDS ${PROJECT_NAME}.elf
	COMMAND avrdude -c ${PROG_STR} -p ${MCU} -U flash:w:${PROJECT_NAME}.hex:i
	COMMENT "flashes the hex file onto the MCU"
)

add_custom_target(flash-debug
	DEPENDS ${PROJECT_NAME}.elf
	COMMAND avrdude -c ${PROG_STR} -p ${MCU} -U flash:w:${PROJECT_NAME}.elf:e
	COMMENT "flashes the elf file onto the MCU"
)
