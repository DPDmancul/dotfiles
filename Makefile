.PHONY: all build doc clean
.PHONY: install install-system install-home

TIMESTAMPS := .timestamps
BUILD := config
DOC := book

ELISP = elisp
EMACS = emacs --batch --no-init-file

all: install doc


install: install-system install-home

install-system: build-system
	sudo nixos-rebuild switch -f "$(BUILD)/configuration.nix"

install-home: build-home
	home-manager switch -f "$(BUILD)/home.nix"


build: build-system build-home

build-%: src/%
	mkdir -p $(BUILD)
	cd $(BUILD) && lmt `find ../$</ -type f -name '*.md'`


doc:
	mdbook build
	@cp -r img $(DOC)/


clean:
	rm -rf $(BUILD) $(DOC)
	rm -rf $(TIMESTAMPS)

