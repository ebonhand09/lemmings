				INCLUDE	"definitions.asm"		; Lemmings shared defs

				SECTION .payload_levelorder_physical_map	; ORG	$FFA3
				FCB	LevelOrder_Block
				ENDSECTION

				SECTION	.payload_levelorder			; ORG	$6000
LevelOrder			EXPORT
OddTable			EXPORT
LevelOrder			INCLUDEBIN	"../bin/levelorder.bin"
OddTable			INCLUDEBIN	"../bin/oddtable.bin"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_0	; ORG	$FFA4
				FCB	LevelData_Block
				ENDSECTION

				SECTION .payload_leveldata_0
				INCLUDEBIN	"../bin/levels.bin.0"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_1	; ORG	$FFA4
				FCB	LevelData_Block+1
				ENDSECTION

				SECTION .payload_leveldata_1
				INCLUDEBIN	"../bin/levels.bin.1"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_2	; ORG	$FFA4
				FCB	LevelData_Block+2
				ENDSECTION

				SECTION .payload_leveldata_2
				INCLUDEBIN	"../bin/levels.bin.2"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_3	; ORG	$FFA4
				FCB	LevelData_Block+3
				ENDSECTION

				SECTION .payload_leveldata_3
				INCLUDEBIN	"../bin/levels.bin.3"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_4	; ORG	$FFA4
				FCB	LevelData_Block+4
				ENDSECTION

				SECTION .payload_leveldata_4
				INCLUDEBIN	"../bin/levels.bin.4"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_5	; ORG	$FFA4
				FCB	LevelData_Block+5
				ENDSECTION

				SECTION .payload_leveldata_5
				INCLUDEBIN	"../bin/levels.bin.5"
				ENDSECTION

				SECTION .payload_leveldata_physical_map_6	; ORG	$FFA4
				FCB	LevelData_Block+6
				ENDSECTION

				SECTION .payload_leveldata_6
				INCLUDEBIN	"../bin/levels.bin.6"
				ENDSECTION
