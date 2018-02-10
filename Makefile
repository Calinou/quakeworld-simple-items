all: dist
PHONY: all

svgs = \
	bmodels/simple_b_bh10_0.svg \
	bmodels/simple_b_bh25_0.svg \
	bmodels/simple_b_bh100_0.svg \
	models/simple_armor_0.svg \
	models/simple_armor_1.svg \
	models/simple_armor_2.svg \
	models/simple_invulner_0.svg \
	models/simple_quaddama_0.svg \

# Render SVGs to PNG images and optimize them
dist: clean
	mkdir -p "dist/textures/bmodels" "dist/textures/models"; \
	for vector in $(svgs); do \
		raster="dist/textures/$${vector%.*}.png"; \
		inkscape "src/textures/$$vector" --export-png "$$raster"; \
		oxipng -o6 --strip all "$$raster"; \
	done; \

clean:
	rm -rf dist; \
