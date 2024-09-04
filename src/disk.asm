disk_load:
	push dx
	mov ax, 0x03
	push ax
	mov ah, 0x0						; Reset
	mov dl, [BOOTDRIVE]				; Drive Numeber (Floopy = 0)
	int 0x13

	mov bx, _BOOT_SECTOR_2_			; Set where to load data to
	mov es, bx
	mov bx, 0x0						; ES:BX: 0x7e00:0x0000

	mov ch, 0x00					; Track 0
	mov cl, 0x02					; Sector 2 (Next 512 bytes)
	mov dh, 0x00					; Head number

.int13_call:
	mov ah, 0x02					; Read disk sector interrupt
	mov al, 0x01					; Sectors to read
	int 0x13						; Read sectors

	push ax

	jc .check_retry					; Attempt retry up to 3 times

	pop bx
	cmp bl, al						; Error with n disk read
	jne .disk_error

	ret

.check_retry:
	pop ax
	cmp ax, 0
	jg .retry
	;call .disk_error
	ret
.retry:
	dec ax
	push ax
	jmp .int13_call

.disk_error:
	mov si, .disk_error
	call print_str
	ret

disk_error_msg:
	db "Error loading from disk", 0
