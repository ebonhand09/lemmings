			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE	"definitions.asm"		; Lemmings shared defs

			SECTION .bss,bss
current_level_number	RMB	1
scroll_start_location	RMB	2
main_chunk_counter	RMB	2
current_level_number	EXPORT
ENDLOOP			EXPORT
			ENDSECTION

			SECTION program_code
ProgramCode		EXPORT
ProgramCode		;** To be loaded at $C000
			
			orcc	#$50			; Disable interrupts (just in case)
			lds	#Stack			; Relocate stack
			
; Init Code goes here
			jsr	set_palette
			jsr	clear_graphics_320
			jsr	set_graphics_320_mode
			jsr	clear_virtual_world
; level preparation
			lda	#0
			sta	current_level_number	; reset current level to zero

			jsr	extract_current_level	; grab the current level to set area
			
			jsr	slz_uncompress_terrain

			jsr	draw_level_terrain


ENDLOOP			jmp	ENDLOOP
			ENDSECTION

			SECTION	.program_code_stack
Stack			EXPORT
			rmb 	255
Stack			EQU	*
			ENDSECTION
