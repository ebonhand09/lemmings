			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE "definitions.asm"

			SECTION .bss,bss
oddtable_entry_offset	RMB	2
scroll_start_location	RMB	2
; uses global "current_level_number"
; uses global "terrain_id"
; uses global "terrain_drawmode"
; uses global "terrain_xpos"
; uses global "terrain_ypos"
main_chunk_counter	RMB	2
			ENDSECTION

			SECTION	module_level
extract_current_level	EXPORT
draw_level_terrain	EXPORT

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
			; TODO: do oddtable stuff here
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


;*** draw_level_terrain
;	reads the current level data, loops over each terrain piece, decodes the data and 
;	calls the draw routines to plot the terrain to the virtual world
; ENTRY:	none
; EXIT:		none
; DESTROYS:	everything

draw_level_terrain
			; should I be saving the mappings here?
		
			;** Get LevelData into ram
			lda	#CurrentLevel_Block	; LevelData
			sta	$FFA4			; $8000

			ldy	#$8000+CurrentLevel_Offset	; y = start of level

;			ldx	LevelStruct.ScreenStart,y	; hacked out - start @ 0 TODO: fix this
			ldx	#0
			stx	scroll_start_location		; was _pc_start_loc
			ldx	LevelStruct.TotalTerrain,y	; x now holds the count
			stx	main_chunk_counter		; keep it
			ldd	LevelStruct.TerrainOffset,y	; y should now point to first levelchunk
			leay	d,y

_next_level_chunk	
			pshs	y				; keep struct for later

			; Get Draw Mode and X Position
			ldd	LevelTerrainStruct.DrawModeXPos,y
			pshs	d				; save for later
			lsra
			lsra
			lsra
			lsra
			sta	terrain_drawmode

			puls	d
			anda	#$0F
			subd	#$10				; compensate for #$00 = -16
			std	terrain_xpos

			; Get Terrain ID and YPos

			ldd	LevelTerrainStruct.YPosTerrainID,y	; horizontal loc
			pshs	d
			andb	#%00111111
			stb	terrain_id
			
			; this piece of code is just a faster way to do (asra; rorb) x 7
			puls	d
			lslb
			tfr	a,b
			sex
			rolb
			subd	#$20				; compensate for #$00 = -32
			stb	terrain_ypos

;			lbsr	draw_terrain_chunk

;_nlc_post_draw		puls	y			; y = chunk just drawn
;			leay	sizeof{LevelTerrainStruct},y ; move to next chunk
;			ldx	_main_chunk_counter	; get and dec counter
;			leax	-1,x
;			stx	_main_chunk_counter
;			cmpx	#0
;			bne	_next_level_chunk
			puls y
			rts
