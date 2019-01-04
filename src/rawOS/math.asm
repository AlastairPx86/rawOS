
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
; OUTPUT: si = quota, dx = remainder
ros_math_divide:
    push cx
    push di
    push ax
    push bx
    mov cx, 0h
    add si, 1h
ros_math_divide_repeat:
    cmp ax, bx
    jl ros_math_divide_add
    sub ax, bx
    add cl, 1h
    jmp ros_math_divide_repeat
ros_math_divide_add:
    cmp ch, 0h
    je ros_math_divide_add_si
    jmp ros_math_divide_add_re
ros_math_divide_add_si:
    mov di, cl
    jmp ros_math_divide_check
ros_math_divide_add_re:
    push ax
    push si
    mov ax, dx
    mov si, Ah
    call ros_math_multiply
    mov dx, si
    pop si
    pop ax
    add dx, cl
ros_math_divide_check:
    add ch, 1h
    push si
    mov si, Ah
    call ros_math_multiply
    mov ax, si
    pop si
    cmp ch, si
    je ros_math_divide_done
    jmp ros_math_divide_repeat
ros_math_divide_done:
    mov si, di
    pop bx
    pop ax
    pop di
    pop cx
    ret