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
			jsr	set_graphics_320_mode

			jsr	set_palette

			lda	#ScreenBuffer_Block
			sta	$FFA4
; clear a chunk of video
			ldb	#$0
			ldx	#$8000
			ldy	#$2000
!			stb	,x+
			leay	-1,y
			bne	<
; end clear chunk

; establish level order table
			lda	#LevelOrder_Block
			sta	LevelOrder_Reg
			ldx	#LevelOrder_Window	; X now points to LevelOrder

; get first level data	
			lda	,x			; get block info
			cmpa	#$ff			; is it an oddtable reference?
			bne	>			; brifnot
			; do oddtable stuff here
			; e.g. set oddtable flags
			; and point routine to the raw level data
			jmp	ENDLOOP	;; hack for now

!			



ENDLOOP			jmp	ENDLOOP
			ENDSECTION

			SECTION	.program_code_stack
Stack			EXPORT
			rmb 	255
Stack			EQU	*
			ENDSECTION
