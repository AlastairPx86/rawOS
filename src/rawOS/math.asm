
; Perfoms the modulo operation (https://en.wikipedia.org/wiki/Modulo_operation)
; 

; Divides two numbers and returns the quotient and the decimals
; INPUT: dx:ax = value to divide, bx = divisor, si = max length of decimal
; OUTPUT: ax = quotient, dx = decimals
ros_math_divide:
    push cx
    push si
    push di
    mov cx, 0
    add si, 1
ros_math_divide_repeat:
    div bx
    cmp dx, 0
ros_math_divide_done:
    mov di, Ah
    mul
    