; Routines to deal with the virtual world

			INCLUDE	"hardware-defs.asm"		; Coco hardware definitions
			INCLUDE "definitions.asm"

			SECTION .bss,bss
_a_private_var		RMB	16
			ENDSECTION

			SECTION	module_virtualworld
clear_virtual_world	EXPORT
map_virtual_screen	EXPORT
get_addr_start_of_line	EXPORT


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

;*** map_virtual_screen
;	set logical blocks 0, 1 and 2 pointing at the virtual screen triplet
;	specified by register A (0 - 4).
;	Assumes windows 0,1,2
; ENTRY:	a = virtual screen triplet to be mapped

map_virtual_screen
			pshs	a,u			; Save previous values
			ldu	#GIME.MMU0		; Get pointer to task-0 regs
			lsla				; multiply a by two
			adda	,s+			; add previous value of a - a = a * 3
			sta	,u			; map first page of vsbank to vswindow0
			inca				; next page
			sta	1,u			; map second page of vsbank to vswindow1
			inca				; next page
			sta	2,u			; map third page of vsbank to vswindow2
			puls	u			; clean up stack
			rts

;*** get_addr_start_of_line
;	set D to point at the first byte of vertical line specified in register A
;	Note that this routine also remaps the virtual screen
; ENTRY:	a = Vertical offset to be calculated
; EXIT:		d = first byte of vertical offset specified in register A
; DESTROYS:	a,b/d

get_addr_start_of_line
			pshs	a			; Save vertical offset for later use
			lsra				; / 2
			lsra				; / 4
			lsra				; / 8
			lsra				; / 16
			lsra				; / 32 = vsbank
			lbsr	map_virtual_screen	; a = correct vsbank to be mapped
			;** By reaching here, the correct vsbank is mapped to windows 0,1,2
			;** Calculate the start of the correct vertical line within the vswindow
			puls	a			; pushed earlier - vertical line
			anda	#31			; lower bits = vertical offset within bank
			pshs	a
			lsla				; * 2
			adda	,s+			; a = a *3
			clrb				; bottom of b isn't needed
			;** By reaching here, the correct starting byte of the line is stored in D
			rts
