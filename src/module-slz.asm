;; This is implementation of the SLZ uncompression routine - I didn't write it

			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE "definitions.asm"

			SECTION .bss,bss
slz_tag			RMB	1
slz_len			RMB	1
			ENDSECTION

			SECTION	module_slz
slz_uncompress		EXPORT
slz_uncompress_terrain	EXPORT

;*** slz_uncompress
;	Uncompress SLZ data - I didn't write this
; ENTRY:	X - destination address
;		Y - source address
; EXIT:		none
; DESTROYS:	everything
slz_uncompress
			clr	slz_len				; from the original source
slz_1			ldb	,y+				; get next compression tag
			stb	slz_tag				; save tag
			lda	#8				; repeat for each bit of tag

slz_2			rol	slz_tag				; rotate in fix byte
			bcs	slz_3				; if set, do dictionary lookup
			ldb	,y+				; copy one byte
			stb	,x+				; to image

slz_5			deca					; bump counter
			bne	slz_2				; rinse / repeat
			bra	slz_1				; go get next tag

slz_3			pshs	a				; save counter
			ldd	,y++				; D = length/offset
			tsta
			beq	slz_exit			; is zero, so end of data
			pshs	y
			pshs	a
			anda	#%00001111			; A = length
			adda	#2
			sta	slz_len				; save length
			puls	a
			lsra
			lsra
			lsra
			lsra					; D = offset
			coma 
			comb 
			addd	#1				; D = - offset
			leay	d,x				; y = dictionary
			lda	slz_len				; a = counter

slz_4			ldb	,y+				; copy byte from dictionary
			stb	,x+				; to destination
			deca					; bump counter
			bne	slz_4				; repeat
			puls	y
			puls	a
			bra	slz_5

slz_exit		puls	a
			rts


; extract terrain
		  	
;*** slz_uncompress_terrain
;	Uncompress TerrainData for a particular set from SLZ data
; ENTRY:	B - terrain set to extract
; EXIT:		none
; DESTROYS:	everything

slz_uncompress_terrain
; save existing mappings
			ldd	$FFA0
			pshs	d
			ldd	$FFA2
			pshs	d
			ldd	$FFA4
			pshs	d

			lda	#TerrainData_Block
			sta	$FFA0
			inca
			sta	$FFA1
			; Compressed data now in $0000-$3FFF

			lda	#ScreenBuffer0_Block
			sta	$FFA2
			inca
			sta	$FFA3
			inca
			sta	$FFA4
			inca
			sta	$FFA5
			; Screen Buffer 0 / temporary decompression space
			; now in $4000 - $BFFF

			; Y = source, X = dest
			ldy	#$0000
			ldx	#$4000
			jsr	slz_uncompress

; restore previous mappings
			puls	d
			std	$FFA4
			puls	d
			std	$FFA2
			puls	d
			std	$FFA0

			rts
