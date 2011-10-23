			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE "definitions.asm"

			SECTION .bss,bss
_oddtable_entry_offset	RMB	2
; uses global "current_level_number"
			ENDSECTION

			SECTION	module_gfx
extract_current_level	EXPORT

;*** extract_current_level
;	looks up the level number specified by "current_level_number" and copies the level data (including the replacement
;	header information) to CurrentLevel_Block / CurrentLevel_Window+CurrentLevel_Offset
; ENTRY:	none
; EXIT:		none
; DESTROYS:	everything

extract_current_level
; save previous mappings
			lda	LevelOrder_Reg
			pshs	a
			lda	LevelData_Reg
			pshs	a
; establish level order table
			lda	#LevelOrder_Block
			sta	LevelOrder_Reg
			ldx	#LevelOrder_Window+LevelOrder_Offset	; X now points to LevelOrder

; get first level data	
			lda	,x+			; get block info
			cmpa	#$ff			; is it an oddtable reference?
			bne	>			; brifnot
; process oddtable entry
			; do oddtable stuff here
			; e.g. set oddtable flags
			; and point routine to the raw level data
; process normal entry 
!		
			adda	#LevelData_Block
			sta	LevelData_Reg
			ldd	,x++			; get real data offset
!			cmpd	#$2000
			blo	>
			subd	#$2000
			inc	LevelData_Reg
			bra	<
!			ldu	#LevelData_Window
			leau	d,u			; x now points at real data
			ldy	#CurrentLevel_Window+CurrentLevel_Offset	; this shares a block with LevelOrder
			ldx	,x

; copy level data to CurrentLevel area
!			lda	,u+
			sta	,y+
			leax	-1,x
			bne	<

; restore previous mappings
			puls	a
			sta	LevelData_Reg
			puls	a
			sta	LevelOrder_Reg

; current level data can now be found at block #CurrentLevel_Block at offset #CurrentLevel_Offset
			rts

