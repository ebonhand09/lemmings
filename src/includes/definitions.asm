; Block, Page and Window definitions

VirtualWorld_Block		EQU	$0

ScreenBuffer0_Phys		EQU	$3C		; Hack, replace with multi-buffer
ScreenBuffer0_Block		EQU	$0F
ScreenBuffer1_Phys		EQU	$48		; Hack, replace with multi-buffer
ScreenBuffer1_Block		EQU	$13

LevelOrder_Block		EQU	$1E		; physical block 0x20
LevelOrder_Reg			EQU	$FFA3		; gime map reg 0xfa3
LevelOrder_Window		EQU	$6000		; virtual block 0x6000
LevelOrder_Offset		EQU	$6E0		; begins after oddtable

LevelData_Block			EQU	$24		; physical block 0x24
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
TerrainSetData0			EQU	$0

TerrainOffsetTable_Block	EQU	$1F
TerrainOffsetTable_Reg		EQU	$FFA5
TerrainOffsetTable_Window	EQU	$A000

CurrentTerrain_Block		EQU	$0F		; Shares ScreenBuffer0


LevelStruct		STRUCT
Title				RMB	32
ReleaseRate			RMB	1
NumberOfLemmings		RMB	1
NumberToRescue			RMB	1
TimeLimit			RMB	1
MaxClimbers			RMB	1
MaxFloaters			RMB	1
MaxBombers			RMB	1
MaxBlockers			RMB	1
MaxBuilders			RMB	1
MaxBashers			RMB	1
MaxMiners			RMB	1
MaxDiggers			RMB	1
ScreenStart			RMB	1
GraphicSet			RMB	1
TotalObjects			RMB	1
TotalSteel			RMB	1
SteelOffset			RMB	2
TotalTerrain			RMB	2
TerrainOffset			RMB	2
			ENDSTRUCT
			
ObjectStruct		STRUCT
DataPointer			RMB	2
DataLength			RMB	2
DataFrames			RMB	1
Width				RMB	1
Height				RMB	1
FrameStart			RMB	1
FrameEnd			RMB	1
TriggerLeft			RMB	1
TriggerTop			RMB	1
TriggerWidth			RMB	1
TriggerHeight			RMB	1
TriggerEffect			RMB	1
SoundEffect			RMB	1
SoundFrame			RMB	1
			ENDSTRUCT
			
TerrainStruct		STRUCT
DataPointer			RMB	2
Width				RMB	1
Height				RMB	1
			ENDSTRUCT

LevelObjectStruct	STRUCT
ID				RMB	1
PosLeft				RMB	2
PosTop				RMB	1
DrawNotOverlap			RMB	1
DrawOnTerrain			RMB	1
DrawUpsideDown			RMB	1
			ENDSTRUCT
			
LevelTerrainStruct	STRUCT
DrawModeXPos			RMB	2
YPosTerrainID			RMB	2
			ENDSTRUCT
			
LevelSteelStruct	STRUCT
PosLeft				RMB	2
PosTop				RMB	2
PosRight			RMB	2
PosBottom			RMB	2
			ENDSTRUCT

