OUT_NAME="boot"
OUT_FORMAT="bin"				# Linking as binary on .ld

mkdir -p bin
nasm -f elf32 -o bin/boot.o src/boot.asm
cd bin && ld -m elf_i386 -T../boot.ld -o "${OUT_NAME}.${OUT_FORMAT}" **.o
cd ..
