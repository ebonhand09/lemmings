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

; draw a letter, any letter
			lda	#PurpleFont_Block
			sta	PurpleFont_Reg
			ldx	#PurpleFont_Window

; char pick
			lda	#'A			; char number
			suba	#$21			; adjust to ascii
			ldb	#$80			; char size
			mul
			leax	d,x			; do offset
			cmpx	#$8000
			bls	>
			inc	PurpleFont_Reg
			tfr	x,d
			suba	#$20
			tfr	d,x
!

; end char pick

			ldy	#$8000
			lda	#$10			; number of lines
!			ldb	,x+
			stb	,y+
			ldb	,X+
			stb	,y+
			ldb	,x+
			stb	,y+
			ldb	,x+
			stb	,y+
			ldb	,x+
			stb	,y+
			ldb	,x+
			stb	,y+
			ldb	,x+
			stb	,y+
			ldb	,x+
			stb	,y+
			leay	152,y
			deca
			bne	<

			


; end draw a letter, any letter

ENDLOOP			jmp	ENDLOOP
			ENDSECTION

			SECTION	.program_code_stack
Stack			EXPORT
			rmb 	255
Stack			EQU	*
			ENDSECTION
