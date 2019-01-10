
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
; INPUT: ax = interger to be converted
; OUTPUT: si = memory adress with string
; NOTE: last byte of string will always be NULL. String will return in this format: Value = 2732, String = 02732
string times 6 db 0
interger dw 0
stringLoc dw 0
ros_io_tostring:
    pusha
    mov dx, 0 ; Make sure dx is 0 for our division
    mov [interger], ax
    mov bx, 10 ; We're going to divide by 10
    mov di, string ; DI keeps track of our current position in the string
    add di, 4 ; Move position of reader to the first char
ros_io_tostring_repeat:
    div bx ; Now the singular digit is in dx and the rest in ax. For example if the initial value was 7263: ax = 726, dx = 3
    add dx, 0x30 ; Make the singular digit an ascii char
    mov [di], dl ; Move the char into the string. NOTE: We're moving in DL instead of dx because we would overwrite the next byte if we did so (this is not a problem if dx is bigger than 7Fh which it wont)

    cmp di, string ; Check if we're at the start
    je ros_io_tostring_done ; If so: we're done

    sub di, 1 ; Move the reader upwards to the next byte
    mov dx, 0 ; Clear dx
    
    jmp ros_io_tostring_repeat

ros_io_tostring_done:
    mov [stringLoc], di
    popa
    mov si, stringLoc
    ret
