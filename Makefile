all: dist
PHONY: all

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
	models/simple_invisibl_0.svg \
	models/simple_invulner_0.svg \
	models/simple_quaddama_0.svg \

# Render SVGs to PNG images and convert them to TGA
# ezQuake will only override the default simple items from nQuake if they
# are in TGA format
build: clean
	mkdir -p "build/textures/bmodels" "build/textures/models"; \
	for vector in $(svgs); do \
		raster_png="build/textures/$${vector%.*}.png"; \
		raster_tga="build/textures/$${vector%.*}.tga"; \
		inkscape "src/textures/$$vector" --export-png "$$raster_png"; \
		convert "$$raster_png" "$$raster_tga"; \
		rm "$$raster_png"; \
	done; \

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
