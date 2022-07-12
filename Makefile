.PHONY: all build doc clean push

TIMESTAMPS := .timestamps
BUILD := flake
DOC := book

all: build install doc

# delegate to flake makefile
.DEFAULT: $(BUILD)
	cd $(BUILD) && $(MAKE) $@

$(BUILD):
	git submodule update --init --recursive

build: $(BUILD)
	cd $(BUILD) && lmt `find ../ -type f -name '*.md'`

doc:
	mdbook build
	@cp -r img $(DOC)/

clean:
	rm -rf $(DOC) $(TIMESTAMPS)

push:
	git submodule set-url flake "$$(git remote get-url origin)"
	git push --recurse-submodules=on-demand

