	BITS 16
start:
    mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax
    ; -------------------------------------------

    mov bx, 0h ; Set bx as a counter for our loop

    call repeat

    jmp $

    text_string db 'Hello world', 0x0D, 0x0A, 0x00 
main_loop:
    
repeat:
    mov si, text_string ; Move text string into the tranfer registry

    mov ah, 0Eh ; Set ah for interupt: TELETYPE OUTPUT

print_re:
    lodsb
    cmp al, 0
    je print_done
    int 10h
    jmp print_re


print_done:
    add bx, 1h
    cmp bx, 3h
    jl repeat

    ret
    times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature