BITS 32
	section .text
kernel_entry:
	extern _nekOS_main_
	call _nekOS_main_
end:
	hlt
	jmp end
