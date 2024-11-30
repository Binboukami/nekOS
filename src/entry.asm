; file: entry.asm
; description: Meant to be chainloaded at the last stage by the bootloader.
;							 Calls the main kernel.
;							 TODO: This file should be bundled with the main kernel code.

BITS 32
	section .text
kernel_entry:
	extern _nekOS_main_
	call _nekOS_main_
end:
	hlt
	jmp end
