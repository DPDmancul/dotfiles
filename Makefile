.PHONY: all doc clean
.PHONY: build build-system build-home
.PHONY: install install-system install-home

TIMESTAMPS := .timestamps
BUILD := tangled
DOC := public

ELISP = elisp
EMACS = emacs --batch --no-init-file

all: install doc


install: install-system install-home

install-system: build-system
	cp "$(BUILD)/home.nix" ~/.config/nixpkgs/
	sudo nixos-rebuild switch

install-home: build-home
	sudo cp "$(BUILD)/configuration.nix" /etc/nixos/
	home-manager switch


build: build-system build-home

build-%: %
	$(EMACS) --load $(ELISP)/tangle.el <(cat $^/*.org)


doc:
	$(EMACS) --load $(ELISP)/publish.el


clean:
	rm -rf $(BUILD) $(DOC)
	rm -rf $(TIMESTAMPS)

