all: dist
PHONY: all

svgs = models/simple_armor_2.svg

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
