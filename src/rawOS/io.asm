
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
; NOTE: last byte of string will always be NULL.
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

    cmp ax, 0 ; Check if we've done everything
    je ros_io_tostring_done

    sub di, 1 ; Move the reader upwards to the next byte
    mov dx, 0 ; Clear dx
    
    jmp ros_io_tostring_repeat

ros_io_tostring_done:
    mov [stringLoc], di
    popa
    mov si, [stringLoc]
    ret


; Takes in keyboard events until the user presses a certain key. Max size is 256 bytes
; INPUT: al = ASCII character to stop when pressed (if al = 0 then al will be changed to 'ENTER')
; OUTPUT: ax = adress for string, bx = size of string (to prevent an unessecary amout of 0's)
rl_string times 256 db 0
rl_stringLen dw 0
rl_stringLoc dw 0
rl_asciiStop db 0
ros_io_readline:
    pusha
    cmp al, 0
    je ros_io_readline_setEnter
ros_io_readline_next:
    mov [rl_asciiStop], al
    mov di, rl_string ; DI will act as our counter for position in memory
    mov bx, 0
ros_io_readline_repeat:
    mov ax, 0 ; Configure for interupt
    int 16h ; Key keystroke

    cmp al, [rl_asciiStop] ; Check of stop key was pressed
    je ros_io_readline_done

    mov si, al
    call ros_io_printstring

    mov [di], al ; Move char into string
    inc di ; Move reader
    inc bx

ros_io_readline_done:
    mov [rl_stringLen], bx
    mov [rl_stringLoc], di
    popa
    mov bx, [rl_stringLen]
    mov ax, [rl_stringLoc]
    ret

ros_io_readline_setEnter:
    mov al, 0Dh
    jmp ros_io_readline_next
