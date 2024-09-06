BITS 16

	section .text
	global _start

	_BOOT_SECTOR_1_ EQU 0x7C00
	_BOOT_SECTOR_2_ EQU 0x7E00
	_STACK_SEGMNT_	EQU 0x7000
	_STACK_OFFSET_ 	EQU 0xFFFF
	_KERNEL_ADDR_	EQU 0x1000

	CODE_SEG EQU CODE_DESCRIPTOR - GDT_START
	DATA_SEG EQU DATA_DESCRIPTOR - GDT_START

_start:								; should be 0x7C00
	jmp boot_init

%include "src/print.asm"
%include "src/disk.asm"

boot_init:

	mov [BOOTDRIVE], dl				; Store drive passed by BIOS

	; Initialize registers and boot stack
	mov ax, 0x0						; BIOS loads us into CS:IP 0x0000:0x7C00
	mov ds, ax						; Data segment = 0x0000:0x7c00
	mov es, ax						; Extra segment = 0x0000:0x7c00

	mov ax, _STACK_SEGMNT_
	mov bx, _STACK_OFFSET_
	cli								; Disable interrupts
	mov ss, ax
	mov bp, bx
	mov sp, bp
	sti								; Enable interrupts

	; TODO: Gather additional system information
	;; Setup to load additional boot code

	;mov dl, [BOOTDRIVE]			; Comment out, dl hasnt changed
	;mov es, ax						; ES is already 0x0 here
	mov bx, _KERNEL_ADDR_			; Load kernel entry into this address
	call disk_load

	; Set up GDT descriptors
	cli								; Disable interrupts
	lgdt [GDT_DESCRIPTOR]
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	jmp CODE_SEG:protected_mode

	hlt
	jmp $

BITS 32
protected_mode:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x9000
	mov esp, ebp

	jmp 0x1000

; Data and variables

BITS 16
BOOTDRIVE:
		db 0x00

GDT_DESCRIPTOR:
		dw GDT_START - GDT_END -1		; Size
		dd GDT_START					; Base

GDT_START:								; Will setup a flat memory model for paging later
		NULL_DESCRIPTOR:
			dd 0
			dd 0
		CODE_DESCRIPTOR:
			dw 0xFFFF					; First 16 bits in the segment limiter
			dw 0x0000					; First 16 bits in the base address
			db 0						; Additional 8 bits from base address

			db 10011010b				; Type attrs
			db 11001111b				; Flag Bits + 4 bits from Limit (20bits)

			db 0						; Remaining 8bits from Base (32bits)
		DATA_DESCRIPTOR:
			dw 0xFFFF					; First 16 bits in the segment limiter
			dw 0x0000					; First 16 bits in the base address
			db 0						; Additional 8 bits from base address

			db 10010010b
			db 11001111b				; Flag Bits + 4 bits from Limit (20bits)

			db 0						; Remaining 8bits from Base (32bits)
GDT_END:

jmp $
times 510-($-$$) db 0

boot_signt:
	dw 0xAA55						; Legacy BIOS Signature
