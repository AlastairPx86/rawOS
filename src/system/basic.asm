
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

; Reboots the system
system_reboot_message db 'Rebooting...' 0Dh, 0Ah, 0h
ros_system_reboot:
    mov si, system_reboot_message
    call ros_io_printstring
	mov ax, 0
	int 19h