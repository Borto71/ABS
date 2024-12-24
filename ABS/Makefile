# Compiler and tools
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
GDB = arm-none-eabi-gdb
OBJCOPY = arm-none-eabi-objcopy

# Compilation flags
CFLAGS = -g -mcpu=cortex-a7 -Wall
ASFLAGS = -g -mcpu=cortex-a7

# Linker flags
LDFLAGS = -T linker.ld -nostdlib

# Source and object files
SRCDIR = src
OBJDIR = obj
SRCS = $(wildcard $(SRCDIR)/*.s)
OBJS = $(patsubst $(SRCDIR)/%.s, $(OBJDIR)/%.o, $(SRCS))

# Output file
TARGET = main.elf

# Default rule
all: $(TARGET)

# Linking
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

# Assembly compilation
$(OBJDIR)/%.o: $(SRCDIR)/%.s
	@mkdir -p $(OBJDIR)
	$(AS) $(ASFLAGS) $< -o $@

# Clean rule
clean:
	rm -rf $(OBJDIR) $(TARGET)