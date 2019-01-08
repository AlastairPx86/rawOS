
; Perfoms the modulo operation (https://en.wikipedia.org/wiki/Modulo_operation)
; 

; Divides two numbers and returns the quotient and the decimals
; INPUT: dx:ax = value to divide, bx = divisor, si = max length of decimal
; REGISTRY USAGES: dx:ax = value to divide, bx = divisor, cx = program counter, si = max length of decimal, di = temp storage
; OUTPUT: ax = quotient, dx = decimals
quotient dw 0h
remainder dw 0h
ros_math_divide:
    push cx
    push si
    push di
    mov cx, 0
    add si, 1
ros_math_divide_repeat:
    div bx
    cmp cx, 0
    je ros_math_divide_add_q
    jne ros_math_divide_add_r
ros_math_divide_add_q:
    mov [quotient], ax
    jmp ros_math_divide_check
ros_math_divide_add_r:
    
ros_math_divide_check:

ros_math_divide_done:
    mov di, Ah
    mul
    