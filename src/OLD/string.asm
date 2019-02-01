# Counts the length of string
# INPUT: si = string adress
# OUTPUT: fmao-0 = length of string
ros_string_length:
    pusha
    mov bx, 0
ros_string_length_repeat:
    lodsb
    cmp al, 0
    je ros_string_length_done
    inc bx
    jmp ros_string_length_repeat
ros_string_length_done:
    mov [fmao0], bx
    popa
    ret