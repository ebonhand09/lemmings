; Block, Page and Window definitions
ScreenBuffer_Phys		EQU	$48		; Hack, replace with multi-buffer
ScreenBuffer_Block		EQU	$12


PurpleFont_Block		EQU	$20		; physical block 0x20
PurpleFont_Reg			EQU	$FFA3		; gime map reg 0xfa3
PurpleFont_Window		EQU	$6000		; virtual block 0x6000
PurpleFont_Offset		EQU	$0		; begins at start of block
