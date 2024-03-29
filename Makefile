.PHONY: all build doc clean
.PHONY: install update

TIMESTAMPS := .timestamps
SRC := src
BUILD := flake
DOC := book

all: install doc ;

build: remove-tangled
	cd $(BUILD) && lmt $$(find ../ -type f -name '*.md')
	cd "$(SRC)" && find . -type f -not -name '*.md' -exec cp {} ../$(BUILD)/{} \;
	cp -r assets .sops.yaml $(BUILD)/
	sed -i "s*<<<pwd>>>*$$PWD*" $(BUILD)/flake.nix

doc:
	mdbook build
	@cp -r img $(DOC)/

clean: remove-tangled
	rm -rf $(DOC) $(TIMESTAMPS)

.PHONY: remove-tangled
remove-tangled:
	rm -rf $(BUILD)/assets $(BUILD)/.sops.yaml $(BUILD)/pkgs $(BUILD)/overlays
	rm -rf $(BUILD)/installation.sh
	cd "$(SRC)" && find . -mindepth 1 -maxdepth 1 -type d -exec rm -rf ../$(BUILD)/{} ../$(BUILD)/{}.nix \;

# delegate to flake makefile
.delegate-%: $(BUILD)/Makefile
	@cd $(BUILD) && $(MAKE) $*

install update: %: build .delegate-% ;
install-%: build .delegate-install-%;

.DEFAULT:
	@$(MAKE) .delegate-$@

