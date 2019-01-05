
; Multiplies two integers
; INPUT: ax = value 1, si = value 2
; OUTPUT: si = multiplied value
ros_math_multiply:
	push bx
    mov bx, 0
    cmp si, 0
    je ros_math_multiply_done
ros_math_multiply_repeat:
    add bx, ax
    sub si, 1
    cmp si, 0
    je ros_math_multiply_done
    jmp ros_math_multiply_repeat
ros_math_multiply_done:
    mov si, bx
    pop bx
    ret

; Divides two integers
; INPUT: ax = value to divide, bx = value to divide with, si = max length of remainder
; OUTPUT: di = quota, dx = remainder
; VARIABLES:
interger dw 0h
divisor dw 0h
quota dw 0h
remainder dw 0h
cxBackup dw 0h
ros_math_divide:
    push ax ; Push the registries which we do not want to modify
    push bx
    push cx
    push si

    mov interger, ax ; Set variables
    mov divisor, bx
    mov cx, 0h
    add si, 1h ; Needed for the counter to be in sync
ros_math_divide_repeat:
    cmp ax, bx ; Currently cx is the subtraction counter while the positon counter is in cxBackup
    jl ros_math_divide_add
    sub ax, bx
    add cx, 1h
    jmp ros_math_divide_repeat
ros_math_divide_add:
    push cx ; cx and cxBackup swith places
    mov cx, cxBackup
    pop cxBackup

    cmp cx, 0h ; Check if this is the first iteration
    je ros_math_divide_add_q ; If so: add value to quota
ros_math_divide_add_q:
    push cx ; cx and cxBackup swith places
    mov cx, cxBackup
    pop cxBackup

    mov quota, cx ; Set quota
    jmp ros_math_divide_check
ros_math_divide_add_re:
    
ros_math_divide_check:
