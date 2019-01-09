
; Perfoms the modulo operation (https://en.wikipedia.org/wiki/Modulo_operation)
; 


; Works as proxy for MUL (used for basic interpreter and sometimes in api)
; INPUT: ax = value to multiply, bx = value to multily with
; OUTPUT: dx:ax = ax * bx with dx = remainder OR ax = al * bx
ros_math_multiply:
    mul bx
    ret

; Divides two numbers and returns the quotient and the decimals
; INPUT: dx:ax = value to divide, bx = divisor, si = max length of decimal
; REGISTRY USAGES: dx:ax = value to divide, bx = divisor, cx = program counter, si = max length of decimal, di = temp storage
; OUTPUT: ax = quotient, dx = decimals, cx = remainder (if cx becomes bigger or equal to si before it is able to compute the remainder)
quotient dw 0h
decimals dw 0h
ros_math_divide:
    ; Store all registers which we do not want to modify
    push si
    push di
    mov cx, 0h
    add si, 1h
ros_math_divide_repeat:
    div bx
    cmp cx, 0h
    je ros_math_divide_add_q
    jne ros_math_divide_add_r
ros_math_divide_add_q:
    mov [quotient], ax
    jmp ros_math_divide_check
ros_math_divide_add_r:
    ; Multiply existing value by 10 to make room for 'ax'
    push ax
    push bx
    push dx
    mov ax, decimals
    mov bx, 0Ah
    mov dx, 0h
    call ros_math_multiply

    cmp dx, 0 ; Check if value is bigger than 65535
    jne ros_math_divide_decimal_overflow

    mov [decimals], ax

    pop dx
    pop bx
    pop ax
    ; --------------------------
    ; Add 'ax' to decimals
    add [decimals], ax
ros_math_divide_check:
    ; Check if there's no remainder
    cmp dx, 0
    je ros_math_divide_done

    add cx, 1h ; Add 1 to program counter
    cmp cx, si ; Check if we hit max length
    jge ros_math_divide_done 

    ; Move remainder to ax and multiply it by 10
    push bx
    mov ax, dx
    mov dx, 0h ; We don't need dx anymore (in this loop)
    mov bx, 0Ah
    call ros_math_multiply

    cmp dx, 0h ; Check if value is bigger than 65535
    jne ros_math_divide_decimal_overflow

    pop bx

    jmp ros_math_divide_repeat

ros_math_divide_done:
    mov cx, dx
    mov dx, decimals
    mov ax, quotient

    pop di
    pop si
    ret
ros_math_divide_decimal_overflow:
    pusha
    error_string db 'Integer overflow! We currently do not support decimals bigger than 0.65536, althogh this is planned to be fixed', 0Dh, 0Ah, 0h
    mov si, error_string ; Load the adress of 'error_string' into ax
    mov bx, 1h ; While the kernel error handler isn't implemented yet, we reload the system as a temporarily solution
    jmp ros_system_error
