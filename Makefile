.PHONY: all build doc clean

TIMESTAMPS := .timestamps
BUILD := flake
BUILD_GIT := $(BUILD)/.git
DOC := book

all: build install doc

# delegate to flake makefile
.DEFAULT: $(BUILD_GIT)
	cd $(BUILD) && $(MAKE) $@

$(BUILD_GIT):
	git submodule update --init --recursive

build: $(BUILD)
	cd $(BUILD) && lmt `find ../ -type f -name '*.md'`

doc:
	mdbook build
	@cp -r img $(DOC)/

clean:
	rm -rf $(DOC) $(TIMESTAMPS)

