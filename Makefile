CC = gcc
ASM = nasm

OUT_NAME = nekOS
OUT_DIR = bin
OUT_FORMAT = bin

SOURCES = src/kernel.c
CFLAGS = -nostdlib -nostartfiles -ffreestanding -fno-pie -m32 -Wall -Wextra

LOADER_DEPS = src/disk.asm src/print.asm src/boot.asm
KERNEL_DEPS = src/entry.asm src/kernel.c

.PHONY : all clean

all: setup_build bootloader kernel

setup_build:
	mkdir -p bin

bootloader : $(LOADER_DEPS)
	$(ASM) -f elf32 -o bin/boot.o src/boot.asm

kernel: $(KERNEL_DEPS)
	$(ASM) -f elf32 -o bin/entry.o src/entry.asm
	$(CC) -c $(SOURCES) -o bin/kernel.o $(CFLAGS)
	cd bin && ld -m elf_i386 -T../boot.ld -o "${OUT_NAME}.${OUT_FORMAT}" **.o	

clean:
	rm -r bin/*
