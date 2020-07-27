TOOL  = arm-none-eabi
PROG  = /opt/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI
CFLAGS= -mcpu=cortex-m3 -mthumb
PFLAGS= --connect port=/dev/ttyUSB0
CINC  = -IInc
LD    = STM32F103C8Tx_FLASH
STRUP = startup_stm32f103xb
STRTYP= C_FILE
SRC   = main
TARGET= main
CSRC  = Src
BUILD_DIR = build


.PHONY:all clean erase flash

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin

$(BUILD_DIR)/$(SRC).o: $(CSRC)/$(SRC).c Makefile | $(BUILD_DIR)
	$(TOOL)-gcc $(CFLAGS) $(CINC) -c $(CSRC)/$(SRC).c -o $(BUILD_DIR)/$(SRC).o

ifeq ($(STRTYP),C_FILE)
$(BUILD_DIR)/$(STRUP).o: $(STRUP).c Makefile | $(BUILD_DIR)
	$(TOOL)-gcc $(CFLAGS) -c $(STRUP).c -o $(BUILD_DIR)/$(STRUP).o
else
$(BUILD_DIR)/$(STRUP).o: $(STRUP).s Makefile | $(BUILD_DIR)
	$(TOOL)-as $(STRUP).s -o $(BUILD_DIR)/$(STRUP).o
endif

$(BUILD_DIR)/$(TARGET).elf: $(LD).ld $(BUILD_DIR)/$(STRUP).o $(BUILD_DIR)/$(SRC).o Makefile
	$(TOOL)-ld -T $(LD).ld -o $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(STRUP).o $(BUILD_DIR)/$(SRC).o

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET).elf | $(BUILD_DIR)
	$(TOOL)-objcopy -O binary $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
	rm -fR $(BUILD_DIR)

erase:
	$(PROG) $(PFLAGS) --erase all

flash:
	$(PROG) $(PFLAGS) --write $(BUILD_DIR)/$(TARGET).bin 0x08000000
	$(PROG) $(PFLAGS) --start 0x08000000
