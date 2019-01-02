print_string:
	mov ah, 0Eh
print_string_repeat:
    lodsb
    cmp al, 0
    je print_string_done
    int 10h
    jmp print_string_repeat
print_string_done:
    ret