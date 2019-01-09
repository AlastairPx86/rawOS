
; Prints a string located in si to the screen
; INPUT: SI = String value
; Example:
; mov si, string_to_print
; call ros_print_string
ros_io_printstring:
    pusha
	mov ah, 0Eh
ros_io_printstring_repeat:
    lodsb
    cmp al, 0
    je ros_io_printstring_done
    int 10h
    jmp ros_io_printstring_repeat
ros_io_printstring_done:
    popa
    ret

; Prints a single char located in si to the screen
; INPUT: si = char
ros_io_printchar:
    pusha
    mov ah, 0Eh
    lodsb
    cmp al, 0
    je ros_io_printchar_done
    int 10h
ros_io_printchar_done:
    popa
    ret

; Prints a new line
newLineVar db 0Eh, 0Ah, 0h
ros_io_newline:
    push si
    mov si, newLineVar
    call ros_io_printstring
    pop si
    ret
; Converts integer to ascii 
ros_io_tostring:
