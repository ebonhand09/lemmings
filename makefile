# Lemmings v6 makefile
LWASM=lwasm
LWASM_OPTS=--pragma=cescapes,undefextern --includedir=include --includedir=src/includes
LWLINK=lwlink

# Compile Everything
.PHONY: all
all: terrain fonts levels lemmings.dsk

# Game source files
lemmings_srcs := lemmings.asm module-gfx.asm module-font.asm payload.asm
lemmings_srcs := $(addprefix src/,$(lemmings_srcs))

lemmings_objs := $(lemmings_srcs:%.asm=%.o)

# Loader source files
extra_srcs := loader_stage1.asm loader_stage2.asm

# All source files
all_srcs := $(lemmings_srcs) $(extra_srcs)

all_objs := $(lemmings_objs) $(extra_srcs:%.asm=%.o)

# Link script
lemmings_linkscript := src/linkscript

lemmings.bin: $(lemmings_objs) $(lemmings_linkscript)
	$(LWLINK) --format=decb --map=lemmings.map --script=$(lemmings_linkscript) -o $@ $(lemmings_objs)

lemmings.img: loader_stage1.bin loader_stage2.rawbin lemmings.bin
	cat loader_stage1.bin loader_stage2.rawbin lemmings.bin > $@

%.o: %.asm
	$(LWASM) $(LWASM_OPTS) --list=$*.list --symbols --format=obj -o $@ $<

%.bin: %.asm
	$(LWASM) $(LWASM_OPTS) --list=$*.list --symbols --format=decb -o $@ $<

%.rawbin: %.asm
	$(LWASM) $(LWASM_OPTS) --list=$*.list --symbols --format=raw -o $@ $<

lemmings.dsk: lemmings.img
	decb dskini $@
	decb copy $< $@,L.BIN -2 -b

# Compile Fonts
.PHONY: fonts
fonts: bin/font0.bin bin/font1.bin

bin/font0.bin: tools/extract-font.php
	tools/extract-font.php 0

bin/font1.bin: tools/extract-font.php
	tools/extract-font.php 1


# Compile Terrain
.PHONY: terrain
terrain: include/terrain-offset-table-0.asm include/terrain-offset-table-1.asm include/terrain-offset-table-2.asm \
	include/terrain-offset-table-3.asm include/terrain-offset-table-4.asm \
	bin/terrain0.bin bin/terrain1.bin bin/terrain2.bin bin/terrain3.bin bin/terrain4.bin

terrain_0_objs := ter_0_00.dat ter_0_01.dat ter_0_02.dat ter_0_03.dat ter_0_04.dat ter_0_05.dat \
	ter_0_06.dat ter_0_07.dat ter_0_08.dat ter_0_09.dat ter_0_10.dat ter_0_11.dat ter_0_12.dat \
	ter_0_13.dat ter_0_14.dat ter_0_15.dat ter_0_16.dat ter_0_17.dat ter_0_18.dat ter_0_19.dat \
	ter_0_20.dat ter_0_21.dat ter_0_22.dat ter_0_23.dat ter_0_24.dat ter_0_25.dat ter_0_26.dat \
	ter_0_27.dat ter_0_28.dat ter_0_29.dat ter_0_30.dat ter_0_31.dat ter_0_32.dat ter_0_33.dat \
	ter_0_34.dat ter_0_35.dat ter_0_36.dat ter_0_37.dat ter_0_38.dat ter_0_39.dat ter_0_40.dat \
	ter_0_41.dat ter_0_42.dat ter_0_43.dat ter_0_44.dat ter_0_45.dat ter_0_46.dat ter_0_47.dat \
	ter_0_48.dat ter_0_49.dat	

terrain_1_objs := ter_1_00.dat ter_1_01.dat ter_1_02.dat ter_1_03.dat ter_1_04.dat ter_1_05.dat \
	ter_1_06.dat ter_1_07.dat ter_1_08.dat ter_1_09.dat ter_1_10.dat ter_1_11.dat ter_1_12.dat \
	ter_1_13.dat ter_1_14.dat ter_1_15.dat ter_1_16.dat ter_1_17.dat ter_1_18.dat ter_1_19.dat \
	ter_1_20.dat ter_1_21.dat ter_1_22.dat ter_1_23.dat ter_1_24.dat ter_1_25.dat ter_1_26.dat \
	ter_1_27.dat ter_1_28.dat ter_1_29.dat ter_1_30.dat ter_1_31.dat ter_1_32.dat ter_1_33.dat \
	ter_1_34.dat ter_1_35.dat ter_1_36.dat ter_1_37.dat ter_1_38.dat ter_1_39.dat ter_1_40.dat \
	ter_1_41.dat ter_1_42.dat ter_1_43.dat ter_1_44.dat ter_1_45.dat ter_1_46.dat ter_1_47.dat \
	ter_1_48.dat ter_1_49.dat ter_1_50.dat ter_1_51.dat ter_1_52.dat ter_1_53.dat ter_1_54.dat \
	ter_1_55.dat ter_1_56.dat ter_1_57.dat ter_1_58.dat ter_1_59.dat ter_1_60.dat ter_1_61.dat \
	ter_1_62.dat ter_1_63.dat

terrain_2_objs := ter_2_00.dat ter_2_01.dat ter_2_02.dat ter_2_03.dat ter_2_04.dat ter_2_05.dat \
	ter_2_06.dat ter_2_07.dat ter_2_08.dat ter_2_09.dat ter_2_10.dat ter_2_11.dat ter_2_12.dat \
	ter_2_13.dat ter_2_14.dat ter_2_15.dat ter_2_16.dat ter_2_17.dat ter_2_18.dat ter_2_19.dat \
	ter_2_20.dat ter_2_21.dat ter_2_22.dat ter_2_23.dat ter_2_24.dat ter_2_25.dat ter_2_26.dat \
	ter_2_27.dat ter_2_28.dat ter_2_29.dat ter_2_30.dat ter_2_31.dat ter_2_32.dat ter_2_33.dat \
	ter_2_34.dat ter_2_35.dat ter_2_36.dat ter_2_37.dat ter_2_38.dat ter_2_39.dat ter_2_40.dat \
	ter_2_41.dat ter_2_42.dat ter_2_43.dat ter_2_44.dat ter_2_45.dat ter_2_46.dat ter_2_47.dat \
	ter_2_48.dat ter_2_49.dat ter_2_50.dat ter_2_51.dat ter_2_52.dat ter_2_53.dat ter_2_54.dat \
	ter_2_55.dat ter_2_56.dat ter_2_57.dat ter_2_58.dat ter_2_59.dat

terrain_3_objs := ter_3_00.dat ter_3_01.dat ter_3_02.dat ter_3_03.dat ter_3_04.dat ter_3_05.dat \
	ter_3_06.dat ter_3_07.dat ter_3_08.dat ter_3_09.dat ter_3_10.dat ter_3_11.dat ter_3_12.dat \
	ter_3_13.dat ter_3_14.dat ter_3_15.dat ter_3_16.dat ter_3_17.dat ter_3_18.dat ter_3_19.dat \
	ter_3_20.dat ter_3_21.dat ter_3_22.dat ter_3_23.dat ter_3_24.dat ter_3_25.dat ter_3_26.dat \
	ter_3_27.dat ter_3_28.dat ter_3_29.dat ter_3_30.dat ter_3_31.dat ter_3_32.dat ter_3_33.dat \
	ter_3_34.dat ter_3_35.dat ter_3_36.dat ter_3_37.dat ter_3_38.dat ter_3_39.dat ter_3_40.dat \
	ter_3_41.dat ter_3_42.dat ter_3_43.dat ter_3_44.dat ter_3_45.dat ter_3_46.dat ter_3_47.dat \
	ter_3_48.dat ter_3_49.dat ter_3_50.dat ter_3_51.dat ter_3_52.dat ter_3_53.dat ter_3_54.dat \
	ter_3_55.dat ter_3_56.dat ter_3_57.dat ter_3_58.dat ter_3_59.dat ter_3_60.dat ter_3_61.dat

terrain_4_objs := ter_4_00.dat ter_4_01.dat ter_4_02.dat ter_4_03.dat ter_4_04.dat ter_4_05.dat \
	ter_4_06.dat ter_4_07.dat ter_4_08.dat ter_4_09.dat ter_4_10.dat ter_4_11.dat ter_4_12.dat \
	ter_4_13.dat ter_4_14.dat ter_4_15.dat ter_4_16.dat ter_4_17.dat ter_4_18.dat ter_4_19.dat \
	ter_4_20.dat ter_4_21.dat ter_4_22.dat ter_4_23.dat ter_4_24.dat ter_4_25.dat ter_4_26.dat \
	ter_4_27.dat ter_4_28.dat ter_4_29.dat ter_4_30.dat ter_4_31.dat ter_4_32.dat ter_4_33.dat \
	ter_4_34.dat ter_4_35.dat ter_4_36.dat

terrain_0_objs := $(addprefix bin/terrain/,$(terrain_0_objs))
terrain_1_objs := $(addprefix bin/terrain/,$(terrain_1_objs))
terrain_2_objs := $(addprefix bin/terrain/,$(terrain_2_objs))
terrain_3_objs := $(addprefix bin/terrain/,$(terrain_3_objs))
terrain_4_objs := $(addprefix bin/terrain/,$(terrain_4_objs))

include/terrain-offset-table-0.asm: 
	tools/extract-terrain.php 0 > $@
	
include/terrain-offset-table-1.asm: 
	tools/extract-terrain.php 1 > $@

include/terrain-offset-table-2.asm: 
	tools/extract-terrain.php 2 > $@

include/terrain-offset-table-3.asm: 
	tools/extract-terrain.php 3 > $@

include/terrain-offset-table-4.asm: 
	tools/extract-terrain.php 4 > $@

bin/terrain0.bin: $(terrain_0_objs)
	cat $^ > $@

bin/terrain1.bin: $(terrain_1_objs)
	cat $^ > $@

bin/terrain2.bin: $(terrain_2_objs)
	cat $^ > $@

bin/terrain3.bin: $(terrain_3_objs)
	cat $^ > $@

bin/terrain4.bin: $(terrain_4_objs)
	cat $^ > $@

# Compile Levels
.PHONY: levels
levels: terrain bin/levels.bin bin/oddtable.bin bin/levelorder.bin

level_srcs :=  level-0-0.dat  level-0-1.dat  level-0-2.dat  level-0-3.dat  level-0-4.dat  level-0-5.dat  level-0-6.dat  level-0-7.dat \
level-1-0.dat  level-1-1.dat  level-1-2.dat  level-1-3.dat  level-1-4.dat  level-1-5.dat  level-1-6.dat  level-1-7.dat  level-2-0.dat \
level-2-1.dat  level-2-2.dat  level-2-3.dat  level-2-4.dat  level-2-5.dat  level-2-6.dat  level-2-7.dat  level-3-0.dat  level-3-1.dat \
level-3-2.dat  level-3-3.dat  level-3-4.dat  level-3-5.dat  level-3-6.dat  level-3-7.dat  level-4-0.dat  level-4-1.dat  level-4-2.dat \
level-4-3.dat  level-4-4.dat  level-4-5.dat  level-4-6.dat  level-4-7.dat  level-5-0.dat  level-5-1.dat  level-5-2.dat  level-5-3.dat \
level-5-4.dat  level-5-5.dat  level-5-6.dat  level-5-7.dat  level-6-0.dat  level-6-1.dat  level-6-2.dat  level-6-3.dat  level-6-4.dat \
level-6-5.dat  level-6-6.dat  level-6-7.dat  level-7-0.dat  level-7-1.dat  level-7-2.dat  level-7-3.dat  level-7-4.dat  level-7-5.dat \
level-7-6.dat  level-7-7.dat  level-8-0.dat  level-8-1.dat  level-8-2.dat  level-8-3.dat  level-8-4.dat  level-8-5.dat  level-8-6.dat \
level-8-7.dat  level-9-0.dat  level-9-1.dat  level-9-2.dat  level-9-3.dat  level-9-4.dat  level-9-5.dat  level-9-6.dat  level-9-7.dat 

level_objs := $(level_srcs:%.dat=%.lvl)

level_srcs := $(addprefix resources/levels/,$(level_srcs))
level_objs := $(addprefix bin/levels/,$(level_objs))

bin/levels/%.lvl: resources/levels/%.dat tools/convert-level.php 
	tools/convert-level.php $(filter %.dat, $<) $@

bin/levels.bin: $(level_objs)
	cat $^ > $@

bin/levelorder.bin: bin/oddtable.bin

bin/oddtable.bin: $(level_objs) tools/create-oddtable.php
	tools/create-oddtable.php
	
.PHONY: clean
clean:
	rm -f bin/levels/*.lvl
	rm -f bin/levels.bin
	rm -f bin/terrain?.bin
	rm -f bin/terrain/*
	rm -f include/terrain-offset-table-?.asm
	rm -f resources/terrain-adjustment?.php
	rm -f bin/font?.bin
	rm -f bin/oddtable.bin
	rm -f bin/levelorder.bin
	rm -f $(kernel_objs) lemmings.bin lemmings.img lemmings.dsk loader_stage1.bin \
loader_stage2.rawbin lemmings.map
	rm -f *.list
	rm -f src/*.list
	rm -f src/*.o

.PHONY: run
run:	all
	sdlmess -debug -joystick_deadzone 1.100000 -joystick_saturation 0.550000 -skip_gameinfo \
	-ramsize 524288 -keepaspect -frameskip 0 -rompath /home/david/roms -video opengl -numscreens -1 \
	-nomaximize coco3p -floppydisk1 `pwd`/lemmings.dsk \
	2>&1 | cat > /dev/null

