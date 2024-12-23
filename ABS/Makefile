# Definizione della toolchain
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy

# Flag di compilazione
CFLAGS = -mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard -g -Iinclude
ASFLAGS = $(CFLAGS)
LDFLAGS =

# File sorgente
C_SOURCES = src/main.c
ASM_SOURCES = src/algoritmo_ABS.s src/auto_diagnosi.s

# Genera una lista di file oggetto corrispondente ai sorgenti
OBJECTS = $(C_SOURCES:.c=.o) $(ASM_SOURCES:.s=.o)

# Target finale
TARGET = main.elf

# Regole
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@

src/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

src/%.o: src/%.s
	$(CC) $(ASFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)