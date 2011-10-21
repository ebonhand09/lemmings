; Block, Page and Window definitions
ScreenBuffer_Phys		EQU	$48		; Hack, replace with multi-buffer
ScreenBuffer_Block		EQU	$12


LevelOrder_Block		EQU	$20		; physical block 0x20
LevelOrder_Reg			EQU	$FFA3		; gime map reg 0xfa3
LevelOrder_Window		EQU	$6000		; virtual block 0x6000
LevelOrder_Offset		EQU	$0		; begins at start of block

OddTable_Offset			EQU	$258		; 600 decimal

LevelData_Block			EQU	$21		; physical blocks 0x21 through 0x27
LevelData_Reg			EQU	$FFA4		; gime map reg 0xfa4
LevelData_Window		EQU	$8000		; virtual block 0x8000
LevelData_Offset		EQU	$0		; begins at start of block
