MAKEFLAGS += --silent
all: dist
PHONY: all

# Directories where images will be placed
dirs = \
	build/textures/bmodels \
	build/textures/models \
	build/textures/wad

# The SVGs to generate images from
svgs = \
	bmodels/simple_b_batt0_0.svg \
	bmodels/simple_b_batt1_0.svg \
	bmodels/simple_b_bh10_0.svg \
	bmodels/simple_b_bh25_0.svg \
	bmodels/simple_b_bh100_0.svg \
	bmodels/simple_b_nail0_0.svg \
	bmodels/simple_b_nail1_0.svg \
	bmodels/simple_b_rock0_0.svg \
	bmodels/simple_b_rock1_0.svg \
	bmodels/simple_b_shell0_0.svg \
	bmodels/simple_b_shell1_0.svg \
	models/simple_armor_0.svg \
	models/simple_armor_1.svg \
	models/simple_armor_2.svg \
	models/simple_g_light_0.svg \
	models/simple_g_nail_0.svg \
	models/simple_g_nail2_0.svg \
	models/simple_g_rock_0.svg \
	models/simple_g_rock2_0.svg \
	models/simple_g_shot_0.svg \
	models/simple_g_shot_1.svg \
	models/simple_invisibl_0.svg \
	models/simple_invulner_0.svg \
	models/simple_quaddama_0.svg \

# The inventory weapon icons
inventory_weapons = \
	shotgun \
	sshotgun \
	nailgun \
	snailgun \
	rlaunch \
	srlaunch \
	lightng \

# The inventory weapon icon prefixes
# ezQuake requires several variants per weapon for the weapon acquisition
# animation, so we need to generate all of them
inventory_weapon_variants = \
	inv2 \
	inva1 \
	inva2 \
	inva3 \
	inva4 \
	inva5 \

# The ImageMagick options to use for converting weapon icons to inventory icons
inventory_weapon_options = \
	-background transparent \
	-gravity center \
	-resize 256x256 \
	-extent 384x256 \

# Render SVGs to PNG images and convert them to TGA
# Also perform some conversions using ImageMagick for inventory images
# ezQuake will only override the default simple items from nQuake if they
# are in TGA format
build: clean
	mkdir -p $(dirs)

	for vector in $(svgs); do \
		raster_png="build/textures/$${vector%.*}.png"; \
		raster_tga="build/textures/$${vector%.*}.tga"; \
		inkscape "src/textures/$$vector" --export-png "$$raster_png"; \
		convert "$$raster_png" "$$raster_tga"; \
		rm "$$raster_png"; \
	done

	convert \
		"build/textures/models/simple_g_shot_1.tga" \
		$(inventory_weapon_options) \
		"build/textures/wad/inv_shotgun.tga"

	convert \
		"build/textures/models/simple_g_shot_0.tga" \
		$(inventory_weapon_options) \
		"build/textures/wad/inv_sshotgun.tga"

	convert \
		"build/textures/models/simple_g_nail_0.tga" \
		$(inventory_weapon_options) \
		"build/textures/wad/inv_nailgun.tga"

	convert \
		"build/textures/models/simple_g_nail2_0.tga" \
		$(inventory_weapon_options) \
		"build/textures/wad/inv_snailgun.tga"

	convert \
		"build/textures/models/simple_g_rock_0.tga" \
		$(inventory_weapon_options) \
		"build/textures/wad/inv_rlaunch.tga"

	convert \
		"build/textures/models/simple_g_rock2_0.tga" \
		$(inventory_weapon_options) \
		"build/textures/wad/inv_srlaunch.tga"

	convert \
		"build/textures/models/simple_g_light_0.tga" \
		$(inventory_weapon_options) \
		-gravity west \
		-extent 768x256 \
		"build/textures/wad/inv_lightng.tga"

	for weapon in $(inventory_weapons); do \
		for variant in $(inventory_weapon_variants); do \
			cp "build/textures/wad/inv_$${weapon}.tga" "build/textures/wad/$${variant}_$${weapon}.tga"; \
		done; \
	done

# Generate a PK3 archive for distribution
# (includes the README and a copy of the license for reference)
dist: build
	mkdir -p "out/"
	cp "README.md" "LICENSE.md" "build/"
	cd "build" && zip -r9 "../out/quakeworld-simple-items.pk3" "textures/" "README.md" "LICENSE.md"
	rm "build/README.md" "build/LICENSE.md"

# Clean up build artifacts
clean:
	rm -rf "build/" "out/"; \
