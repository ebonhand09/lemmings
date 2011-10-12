			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE	"definitions.asm"		; Lemmings shared defs

			SECTION .bss,bss
some_variable_name	RMB	2
some_variable_name	EXPORT					; If it needs to be public
			ENDSECTION

			SECTION program_code
ProgramCode		EXPORT
ProgramCode		;** To be loaded at $C000
			
			orcc	#$50			; Disable interrupts (just in case)
			lds	#Stack			; Relocate stack
			
; Code goes here

ENDLOOP			jmp	ENDLOOP
			ENDSECTION

			SECTION	.program_code_stack
Stack			EXPORT
			rmb 	255
Stack			EQU	*
			ENDSECTION
