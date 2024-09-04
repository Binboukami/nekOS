print_str:
	pusha								; Backup registers
	call print
	popa								; Restore registers
	ret

print_hex: 								; TODO
	pusha
	; for numbers, map 0d-9d to 0x30-0x39
	; for letters, map 10d-15d to 0x41-0x46

	mov dx, [si]						; Load hex value to print
	mov cx, 0x4

.hex_loop:
	dec cx

	mov bx, hex_out						; address of 0x0000
	add bx, 0x02						; skip '0x'
	add bx, cx							; add index of current char

	mov ax, dx							; Copy to bx for masking
	shr dx, 0x4							; shift for the next char,
										; will be used in next iteration

	and al, 0x0F 						; isolate last char

	; add al, 0x20						; Offset by 48d = ASCII for 0
	cmp al, 0x0A
	jl .set_byte						; if its < 10, skip adding more offset
	add al, 0x07						; Offset letters by 55d
.set_byte:
	add byte [bx], al
	cmp cx, 0x0
	je .hex_done
	jmp .hex_loop
.hex_done:
	mov si, hex_out
	call print
	popa
	ret

print:
	mov ax, 0x0
	mov ah, 0x0E						; Set TTY mode
.loc01:
	mov bx, [si]						; Copy address stored in SI to BX
	mov al, bl							; Copy lower bytes from BX to AX
	cmp al, 0x0
	jnz .loc02							; Check if AL is 0
	ret
.loc02:									; If AL is not 0
	int 0x10							; Print ASCII char in AL
	inc si								; Increment SI address
	jmp .loc01							; Loop

hex_out:
	db '0x0000', 0x0
