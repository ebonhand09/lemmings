				INCLUDE	"definitions.asm"		; Lemmings shared defs

				SECTION .payload_levelorder_physical_map	; ORG	$FFA3
				FCB	LevelOrder_Block
				ENDSECTION

				SECTION	.payload_levelorder			; ORG	$6000
LevelOrder			EXPORT
OddTable			EXPORT
OddTable			INCLUDEBIN	"../bin/oddtable.bin"
LevelOrder			INCLUDEBIN	"../bin/levelorder.bin"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_0	; ORG	$FFA4
				FCB	LevelData_Block
				ENDSECTION

				SECTION .payload_leveldata_0
				INCLUDEBIN	"../bin/levels.bin"
				ENDSECTION

				SECTION .payload_terraindata_physical_map_0	; ORG	$FFA3
				FCB	TerrainData_Block,TerrainData_Block+1	; temp 2 blocks
				; will fill out to the full 7 once all sets are being included
				ENDSECTION
				
				SECTION .payload_terraindata_0			; ORG	$6000
Terrain0Data			EXPORT
Terrain0Data			INCLUDEBIN	"../bin/terrain0.slz" 
				ENDSECTION
