# https://freertos.org/Creating-a-new-FreeRTOS-project.html
# Based on /opt/optsync/FreeRTOS/FreeRTOS/Demo/Posix_GCC/Makefile

CC := gcc
BIN := modelo-posix-gcc

BUILD_DIR := build

FREERTOS_DIR_REL := ${FREERTOS_PATH}/FreeRTOS
FREERTOS_DIR := $(abspath $(FREERTOS_DIR_REL))

FREERTOS_PLUS_DIR_REL := ${FREERTOS_PATH}/FreeRTOS-Plus
FREERTOS_PLUS_DIR := $(abspath $(FREERTOS_PLUS_DIR_REL))

INCLUDE_DIRS := -I./include
INCLUDE_DIRS += -I${FREERTOS_DIR}/Source/include
INCLUDE_DIRS += -I${FREERTOS_DIR}/Source/portable/ThirdParty/GCC/Posix

SOURCE_FILES := $(wildcard ./src/*.c)
SOURCE_FILES += ${FREERTOS_DIR}/Source/tasks.c
SOURCE_FILES += ${FREERTOS_DIR}/Source/queue.c
SOURCE_FILES += ${FREERTOS_DIR}/Source/list.c
SOURCE_FILES += ${FREERTOS_DIR}/Source/timers.c
# Memory manager (use malloc() / free())
SOURCE_FILES += ${FREERTOS_DIR}/Source/portable/MemMang/heap_3.c
# Posix port
SOURCE_FILES += ${FREERTOS_DIR}/Source/portable/ThirdParty/GCC/Posix/port.c
SOURCE_FILES += ${FREERTOS_DIR}/Source/portable/ThirdParty/GCC/Posix/utils/wait_for_event.c

CFLAGS := -ggdb3 -O0
LDFLAGS := -ggdb3 -O0 -pthread

OBJ_FILES = $(SOURCE_FILES:%.c=$(BUILD_DIR)/%.o)

DEP_FILE = $(OBJ_FILES:%.o=%.d)

${BIN} : $(BUILD_DIR)/$(BIN)

${BUILD_DIR}/${BIN} : ${OBJ_FILES}
	-mkdir -p ${@D}
	$(CC) $^ $(CFLAGS) $(INCLUDE_DIRS) ${LDFLAGS} -o $@

-include ${DEP_FILE}

${BUILD_DIR}/%.o : %.c
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) ${INCLUDE_DIRS} -MMD -c $< -o $@

.PHONY: clean

clean:
	-rm -rf $(BUILD_DIR)