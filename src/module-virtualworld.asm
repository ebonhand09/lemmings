; Routines to deal with the virtual world

			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE "definitions.asm"

			SECTION .bss,bss
_a_private_var		RMB	16
			ENDSECTION

			SECTION	module_virtualworld
clear_virtual_world	EXPORT

;*** clear_virtual_world
;	save the mapped blocks for FFA0 through FFA4, map those blocks to the four physical blocks for
;	the first (and then second) video buffers, and clear them to zero
;	then, restore the saved mappings
; ENTRY:	none
; EXIT:		none
; DESTROYS:	pretty much everything
clear_virtual_world
; save existing mapping
			lda	$FFA0
			pshs	a
; map to first virtual screen
			lda	#0				; hard coding this - Virtual World is 0x00 through 0x0e
			sta	$FFA0
			ldb	#$0
; clear a chunk of video
clear_virtual_world_1	
			ldx	#0
!			stb	,x+
			cmpx	#$2000
			bne	<
			inc	$FFA0
			inca
			cmpa	#$0F
			bne	clear_virtual_world_1		; loop back and repeat

; restore previous mappings
			puls	a
			sta	$FFA0
			rts
