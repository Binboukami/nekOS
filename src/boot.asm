BITS 16

	section .text
	global _start

	_BOOT_SECTOR_1_ EQU 0x7C00
	_BOOT_SECTOR_2_ EQU 0x7E00
	_STACK_BADDR_ 	EQU 0x7C00
	_KERNEL_ADDR_	EQU 0x1000

_start:								; should be 0x7C00
	jmp boot_init

%include "src/print.asm"
%include "src/disk.asm"

boot_init:

	; Initialize registers and boot stack
	mov ax, 0x00					; BIOS loads us int 0x7c00
	mov ds, ax						; Data segment = 0x7c00:0x000
	mov es, ax						; Extra segment = 0x7c00:0x000

	mov [BOOTDRIVE], dl				; Store drive passed by BIOS

	cli								; Disable interrupts
	mov ss, ax						; Stack segment = 0x7c00:0x000
	mov bp, _STACK_BADDR_			; Stack Base Pointer
	mov sp, bp 						; Stack = 0x7C00:00000
	sti								; Enable interrupts

	; Stage 1
	; TODO: Get additional system information and bootstrap stuff

	; Stage 2
	; TODO: Jump to _BOOT_SECTOR_2_ and set up stuff to load kernel
	; Read from disc routine
	mov si, a_hex
	call print_hex

	; TODO: Debugging why disk read fails.
	; TODO: Implement print hex to debug error code from registers
	;jnz .load_failed				; Check CF. 0 on Sucess

	;mov si, success_msg
	;call print

	hlt
	jmp $
	;call print
	;jmp 0:_BOOT_SECTOR_2_			; Jump to 2nd stage

.load_failed:
	mov si, failed_msg
	call print

	;	TODO: Setup memory and descriptors
	;	TODO: Call Kernel
	; TODO: Set address where to load kernel (_KERNEL_ADDR_)
	; TODO: Attempt to read Kernel from Disk into Memory
	; TODO: Check for errors
	; TODO: Jump to _KERNEL_ADDR_ (Where kernel was loaded)

	hlt

; Variables
BOOTDRIVE:
	db 0x00

a_ascii:
	db "A", 0
a_hex:
	dw 0xABCD, 0

success_msg:
	db "Success", 0x0D, 0x0A, 0
failed_msg:
	db "Failed", 0x0D, 0x0A, 0

jmp $
times 510-($-$$) db 0

boot_signt:
	dw 0xAA55						; Legacy BIOS Signature

boot_load:
	;mov si, teste
	;call print
	jmp $
teste:
	db 'X', 0
	hlt
