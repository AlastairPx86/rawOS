BITS 16

%DEFINE MIKEOS_VER '0.1'	; OS version number
%DEFINE MIKEOS_API_VER '0.1'; API version

disk_buffer	equ	24576

os_init:
    cli				; Clear interrupts
	mov ax, 0
	mov ss, ax		; Set stack segment and pointer
	mov sp, 0FFFFh
	sti				; Restore interrupts
	cld				; The default direction for string operations
					; will be 'up' - incrementing address in RAM
    string_to_print db 'Hello this is my new kernel', 0x0D, 0x0A, 0x00
	mov si, string_to_print
	call print_string

	jmp $

; INCLUDES -----------------------------------------------------------

%INCLUDE "system/basic.asm"