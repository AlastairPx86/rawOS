BITS 16

%DEFINE OS_VER '0.1'	; OS version number
%DEFINE OS_API_VER '0.1'; API version

disk_buffer	equ	24576

ros_api_callpoints:
    jmp ros_init ; 0000h

	; ./rawOS/io.asm
	jmp ros_io_printstring ; 0003h
	; ./rawOS/system.asm
	jmp ros_system_reboot ; 0006h

	; ./rawOS/math.asm


; Kernel starts here
; Variables:
string_key_wait db 'Press enter to load kernel or r to reboot', 0Dh, 0Ah, 0h
string_key_got_enter db 'Starting system...', 0Dh, 0Ah, 0h
ros_init:
    cli				; Clear interrupts
	mov ax, 0
	mov ss, ax		; Set stack segment and pointer
	mov sp, 0FFFFh
	sti				; Restore interrupts
	cld				; The default direction for string operations
					; will be 'up' - incrementing address in RAM
    mov ax, 2000h			; Set all segments to match where kernel is loaded
	mov ds, ax			; After this, we don't need to bother with
	mov es, ax			; segments ever again, as rawOS and its programs
	mov fs, ax			; live entirely in 64K
	mov gs, ax

	pusha ; Save registries
	cmp byte [key_needed], 0h ; Check if keypress is needed
	je ros_start ; If not: start the os

ros_init_get_keystroke:
	mov si, string_key_wait
	call ros_io_printstring
	mov ax, 0 ; Get keystroke
	int 16h
	cmp al, 0Dh ; Check if key pressed was enter
	je ros_start ; If it was; start the os
	cmp al, 72h ; If it wasn't enter, check if it was 'r'
	je ros_system_reboot ; Reboot the system if the user typed 'r'
	jmp ros_init_get_keystroke ; Else: repeat

; Initialize the api, then find the 
string_v db 'Works', 0h
ros_start:
    mov si, string_key_got_enter
	call ros_io_printstring
    popa
	call ros_api_init

    ; TEST ------------
	mov dx, 0h
	mov ax, 5h
	mov bx, 2h
	mov si, 3h
	call ros_math_divide
	mov ax, 123h
	; ----------

	jmp $
; GLOBAL VARIABLES ---------------------------------------------------

key_needed dw 1h

ERROR_LOCATION dw 0h

; INCLUDES -----------------------------------------------------------

%INCLUDE "rawOS/api.asm"

; IMPORTANT POINTS IN MEMORY