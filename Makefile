.PHONY: all build doc clean
.PHONY: install update

TIMESTAMPS := .timestamps
BUILD := flake
DOC := book

all: install doc ;

build: $(BUILD)
	cd $(BUILD) && lmt $$(find ../ -type f -name '*.md')
	sed -i "s*<<<pwd>>>*$$PWD*" flake/flake.nix

doc:
	mdbook build
	@cp -r img $(DOC)/

clean:
	rm -rf $(DOC) $(TIMESTAMPS)

# delegate to flake makefile
.delegate-%: $(BUILD)/Makefile
	@cd $(BUILD) && $(MAKE) $*

install update: %: build .delegate-% ;
install-%: build .delegate-install-%;

.DEFAULT:
	@$(MAKE) .delegate-$@

$(BUILD)/%:
	git submodule update --init --recursive
	chmod +x -R hooks
	ln -srf hooks/* "$$(git rev-parse --git-path hooks)"

