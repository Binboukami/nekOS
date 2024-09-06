OUT_NAME="nekOS"
OUT_FORMAT="bin"				# Linking as binary on .ld

mkdir -p bin
nasm -f elf32 -o bin/boot.o src/boot.asm
nasm -f elf32 -o bin/entry.o src/entry.asm
gcc -c src/kernel.c -o bin/kernel.o -nostdlib -nostartfiles -ffreestanding -fno-pie -m32 -Wall -Wextra

cd bin
ld -m elf_i386 -T../boot.ld -o "${OUT_NAME}.${OUT_FORMAT}" **.o
