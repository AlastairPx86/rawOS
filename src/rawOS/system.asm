; Reboots the system
ros_system_reboot:
	mov ax, 0
	int 19h

; Displays an error created by the api (not accessible from os vectors). Then make an action based on bx
; INPUT: ax = memory adress of error message, bx = action to take
; bx =
; 0: Do nothing
; 1: Reload the os
; 2: Reboot the computer
; 3: Shutdown the computer
; 4: Kernel error handling (is not implemented yet)
; NOTES: If [ax] = 0 then the 
ros_system_error:
    pusha
    ; Print error message
    mov si, [ax]
    cmp si, 0
    je ros_system_error_action
    call ros_io_newline
    call ros_io_printstring
ros_system_error_action:
    cmp bx, 0
    je ros_system_error_action_0

    cmp bx, 1
    je ros_system_error_action_1

    cmp bx, 2
    je ros_system_error_action_2

    cmp bx, 3
    je ros_system_error_action_3
ros_system_error_action_0:
    popa
    ret
ros_system_error_action_1:
    ; call ros_io_screen_clear // Not implemented yet
    jmp ros_init
ros_system_error_action_2:
    ; call ros_io_screen_clear // Not implemented yet
    jmp ros_system_reboot
ros_system_error_action_3:
    ; NOT IMPLEMENTED YET

    ; TEMP
    ; call ros_io_screen_clear // Not implemented yet
    jmp ros_system_reboot