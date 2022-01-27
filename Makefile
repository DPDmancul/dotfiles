.PHONY: all build doc unlock clean
.PHONY: install install-system install-home

TIMESTAMPS := .timestamps
BUILD := config
DOC := book

ELISP = elisp
EMACS = emacs --batch --no-init-file

all: build install doc


install: install-system install-home

install-system: build-system
	sudo nixos-rebuild switch --upgrade -I nixos-config="./$(BUILD)/configuration.nix"

install-home: build-home
	home-manager switch -f "$(BUILD)/home.nix"


build: build-system build-home build-installation

build-%: src/%
	@mkdir -p $(BUILD)
	cd $(BUILD) && lmt `find ../$</ -type f -name '*.md'`


doc:
	mdbook build
	@cp -r img $(DOC)/

unlock:
	git-crypt unlock

clean:
	rm -rf $(BUILD) $(DOC)
	rm -rf $(TIMESTAMPS)

