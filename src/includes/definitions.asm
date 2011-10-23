; Block, Page and Window definitions
ScreenBuffer0_Phys		EQU	$3C		; Hack, replace with multi-buffer
ScreenBuffer0_Block		EQU	$0F
ScreenBuffer1_Phys		EQU	$48		; Hack, replace with multi-buffer
ScreenBuffer1_Block		EQU	$13

LevelOrder_Block		EQU	$1E		; physical block 0x20
LevelOrder_Reg			EQU	$FFA3		; gime map reg 0xfa3
LevelOrder_Window		EQU	$6000		; virtual block 0x6000
LevelOrder_Offset		EQU	$6E0		; begins after oddtable

LevelData_Block			EQU	$1F		; physical blok 0x21
LevelData_Reg			EQU	$FFA4		; gime map reg 0xfa4
LevelData_Window		EQU	$8000		; virtual block 0x8000
LevelData_Offset		EQU	$0		; begins at start of block

CurrentLevel_Block		EQU	$1E		; physical block 0x20
CurrentLevel_Reg		EQU	$FFA3		; gime map reg 0xfa3
CurrentLevel_Window		EQU	$6000		; virtual block 0x6000
CurrentLevel_Offset		EQU	$1830		; 2k at end of block 0x20

TerrainData_Block		EQU	$17		; physical block 0x17
TerrainData_Reg			EQU	$FFA3		;
TerrainData_Window		EQU	$6000
TerrainData_Offset		EQU	$0
TerrainData_Set1_Offset		EQU	$0

CurrentTerrain_Block		EQU	$0F		; Shares ScreenBuffer0

