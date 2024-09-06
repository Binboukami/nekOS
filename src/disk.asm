disk_load:
	mov ax, 0x03
	mov ah, 0x0						; Reset
	mov dl, [BOOTDRIVE]				; Drive Numeber (Floopy = 0)
	int 0x13

	mov ch, 0x00					; Track 0
	mov cl, 0x02					; Sector 2 (Next 512 bytes)
	mov dh, 0x00					; Head number

.int13_call:
	mov ah, 0x02					; Read disk sector interrupt
	mov al, 0x10					; Sectors to read
	int 0x13						; Read sectors

	jc .disk_error

	; TODO: Print additional information about errors

	ret

.check_retry:
	pop ax
	cmp ax, 0
	jg .retry
	call .disk_error
	ret
.retry:
	dec ax
	push ax
	jmp .int13_call

.disk_error:
	mov si, disk_error_msg
	call print_str
	ret

disk_error_msg:
	db "Error loading from disk", 0
