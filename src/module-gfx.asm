;*** Graphics routines

			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE "definitions.asm"

			SECTION .bss,bss
_a_private_var		RMB	16
			ENDSECTION

			SECTION	module_gfx
set_graphics_256_mode	EXPORT
set_graphics_320_mode	EXPORT
clear_graphics_320	EXPORT
set_palette		EXPORT

;*** set_graphics_256_mode
;	put the coco3 into 256x192x4bpp graphics mode, ntsc, starting at physical location $0000
;	Note that this will need adjusting when a real video location is selected
; ENTRY:	none
; EXIT:		none
; DESTROYS:	a
set_graphics_256_mode
			lda	#GIME_MMUEN|GIME_SCS|GIME_FEXX
			sta	GIME.INIT0		; Set hardware config

			lda	#GIME_BP
			sta	GIME.VMODE		; Set video mode

			lda	#GIME_LPF192|GIME_BPR128|GIME_BPP4
			sta	GIME.VRES		; Set video resolution

			lda	#ScreenBuffer0_Phys	; Hack, replace with real address
			sta	GIME.VOFFSET		; 
			clr	GIME.VOFFSET+1
			clr	GIME.VSCROLL
			clr	GIME.HOFFSET
			rts

;*** set_graphics_320_mode
;	put the coco3 into 320x200x16 graphics mode, ntsc, starting at physical location $0000
;	Note that this will need adjusting when a real video location is selected
; ENTRY:	none
; EXIT:		none
; DESTROYS:	a
set_graphics_320_mode
			lda	#GIME_MMUEN|GIME_SCS|GIME_FEXX
			sta	GIME.INIT0		; Set hardware config

			lda	#GIME_BP
			sta	GIME.VMODE		; Set video mode

			lda	#GIME_LPF200|GIME_BPR160|GIME_BPP4
			sta	GIME.VRES		; Set video resolution

			lda	#ScreenBuffer0_Phys	; Hack, replace with real address
			sta	GIME.VOFFSET		; 
			clr	GIME.VOFFSET+1
			clr	GIME.VSCROLL
			clr	GIME.HOFFSET
			rts

;*** clear_graphics_320
;	save the mapped blocks for FFA0 through FFA4, map those blocks to the four physical blocks for
;	the first (and then second) video buffers, and clear them to zero
;	then, restore the saved mappings
; ENTRY:	none
; EXIT:		none
; DESTROYS:	pretty much everything
clear_graphics_320
; save existing mappings
			ldd	$FFA0
			pshs	d
			ldd	$FFA2
			pshs	d
; map to first virtual screen
			lda	#ScreenBuffer0_Block
			ldx	#$FFA0
			sta	,x+
			inca
			sta	,x+
			inca
			sta	,x+
			inca	
			sta	,x
; clear a chunk of video
			ldb	#$0
			ldx	#$0
			ldy	#$7D00		; one less?
!			stb	,x+
			leay	-1,y
			bne	<
; end clear chunk

; repeat for screen buffer 1
			lda	#ScreenBuffer1_Block
			ldx	#$FFA0
			sta	,x+
			inca
			sta	,x+
			inca
			sta	,x+
			inca	
			sta	,x
; clear a chunk of video
			ldb	#$0
			ldx	#$0
			ldy	#$7D00		; one less?
!			stb	,x+
			leay	-1,y
			bne	<
; end clear chunk

; restore previous mappings
			puls	d
			std	$FFA2
			puls	d
			std	$FFA0

			rts


;*** SetPalette: Configure the palette for the appropriate level. Hard-coded to Grass/0 for now
set_palette
			ldx	#GIME.PALETTE				; set some palette entries
			ldy	#_palette_data
			ldb	#0
!       	        lda     ,Y+
			sta	,X+
			incb
			cmpb    #16
			bne	<
			
			rts
                                
_palette_data
			FCB	%00000000	; 0000	- Black		#000000
			FCB	%00111111	; 0001	- White		#FFFFFF
			FCB	%00010000	; 0010	- Mid-Green	#00AA00
			FCB	%00001111	; 0011	- Off-Blue	#5555FF
			FCB	%00100111	; 0100	- Off-Red	#FF5555
			FCB	%00110111	; 0101	- Orange?	#FFFF55
			FCB	%00111000	; 0110	- Light Grey	#AAAAAA
			;** THE ABOVE ARE STANDARD BETWEEN ALL PALETTES

			;** TERRAIN SET 0 - SOIL
			FCB	%00110100	; 0111	- Duplicate of 8
			FCB	%00110100	; 1000	-		#FFAA00
			FCB	%00100010	; 1001	-		#AA5500
			FCB	%00100000	; 1010	-		#AA0000
			FCB	%00000100	; 1011	-		#550000
			FCB	%00000111	; 1100	-		#555555
			FCB	%00101010	; 1101	-		#AA55AA
			FCB	%00010100	; 1110	-		#55AA00 
			FCB	%00000010	; 1111	-		#005500

			;** TERRAIN SET 1 - HELL
			;FCB	%00110100	; 0111	- Duplicate of 8
			;FCB	%00001010	; 1000	-		#0055AA
			;FCB	%00100000	; 1001	-		#AA0000
			;FCB	%00000111	; 1010	-		#555555
			;FCB	%00000100	; 1011	-		#550000
			;FCB	%00100011	; 1100	-		#AA5555
			;FCB	%00111000	; 1101	-		#AAAAAA
			;FCB	%00100100	; 1110	-		#FF0000 
			;FCB	%00000001	; 1111	-		#000055
			ENDSECTION
