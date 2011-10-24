			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE	"definitions.asm"		; Lemmings shared defs

			SECTION .bss,bss
current_level_number	RMB	1
scroll_start_location	RMB	2
main_chunk_counter	RMB	2
current_level_number	EXPORT
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

			;** Get LevelData into ram
			lda	#CurrentLevel_Block	; LevelData
			sta	$FFA4			; $8000

			ldy	#$8000+CurrentLevel_Offset	; y = start of level
;			ldx	LevelStruct.ScreenStart,y	; hacked out - start @ 0
			ldx	#0
			stx	scroll_start_location		; was _pc_start_loc
			ldx	LevelStruct.TotalTerrain,y	; x now holds the count
			stx	main_chunk_counter		; keep it
			ldd	LevelStruct.TerrainOffset,y	; y should now point to first levelchunk
			leay	d,y



			jmp	ENDLOOP

			;; this bit needs some loving
			;; and this entire chunk, starting from 'get leveldata into ram'
			;; needs to be moved to module-level

_next_level_chunk	
			pshs	y			; keep struct for later
			ldd	LevelTerrainStruct.DrawModeXPos,y	; vertical loc
			; split DrawMode and XPos out
			ldx	LevelTerrainStruct.YPosTerrainID,y	; horizontal loc
			; split YPos and TerrainID out
;			pshs	d
;			clra
;			ldb	LevelTerrainStruct.ID,y	; y now = id
;			tfr	d,y
;			puls	d

;			lbsr	draw_terrain_chunk

;_nlc_post_draw		puls	y			; y = chunk just drawn
;			leay	sizeof{LevelTerrainStruct},y ; move to next chunk
;			ldx	_main_chunk_counter	; get and dec counter
;			leax	-1,x
;			stx	_main_chunk_counter
;			cmpx	#0
;			bne	_next_level_chunk

ENDLOOP			jmp	ENDLOOP
			ENDSECTION

			SECTION	.program_code_stack
Stack			EXPORT
			rmb 	255
Stack			EQU	*
			ENDSECTION
