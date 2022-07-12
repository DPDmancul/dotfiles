.PHONY: all build doc clean

TIMESTAMPS := .timestamps
BUILD := flake
DOC := book

all: build install doc

# delegate to flake makefile
.DEFAULT: $(BUILD)
	cd $(BUILD) && $(MAKE) $@

$(BUILD):
	git submodule init
	git submodule update

build: $(BUILD)
	cd $(BUILD) && lmt `find ../ -type f -name '*.md'`

doc:
	mdbook build
	@cp -r img $(DOC)/

clean:
	rm -rf $(DOC) $(TIMESTAMPS)

