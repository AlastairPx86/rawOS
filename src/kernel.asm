BITS 16

%DEFINE OS_VER '0.1'	; OS version number
%DEFINE OS_API_VER '0.1'; API version

disk_buffer	equ	24576

; This defines all the active features in the kernel
ros_api_callpoints:
    jmp ros_init ; 0000h
    ; 0003h


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
	jmp $

; GLOBAL VARIABLES ---------------------------------------------------

key_needed dw 1h

ERROR_LOCATION dw 0h

fma0 dw 0
fma1 dw 0
fma2 dw 0
fma3 dw 0
fma4 dw 0

fmao0 dw 0
fmao1 dw 0
fmao2 dw 0
fmao3 dw 0
fmao4 dw 0

; INCLUDES -----------------------------------------------------------



; IMPORTANT POINTS IN MEMORY