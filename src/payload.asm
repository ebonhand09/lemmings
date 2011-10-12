				INCLUDE	"definitions.asm"		; Lemmings shared defs

				SECTION .payload_purplefont_physical_map	; ORG	$FFA3
				FCB	PurpleFont_Block,PurpleFont_Block+1
				ENDSECTION
				
				SECTION .payload_purplefont		; ORG	$6000
PurpleFont			EXPORT
PurpleFont			INCLUDEBIN	"../bin/font1.bin" 
				ENDSECTION
				
