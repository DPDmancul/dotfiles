.PHONY: all update build doc unlock clean
.PHONY: install install-system install-home
.PHONY: optimize collect-garbage defrag

TIMESTAMPS := .timestamps
BUILD := config
DOC := book

all: build install doc

update:
	sudo nix-channel --update
	$(MAKE) all

install: install-system install-home

install-system: build-system
	sudo nixos-rebuild switch -I nixos-config="./$(BUILD)/configuration.nix"

install-home: build-home
	home-manager switch -b bak -f "$(BUILD)/home.nix"

optimise:
	nix store optimise --extra-experimental-features nix-command

collect-garbage:
	home-manager expire-generations "-30 days"
	sudo nix-collect-garbage --delete-older-than 90d
	$(MAKE) install-system # update the set of boot entries

defrag:
	sudo mount -o remount rw /nix/store/
	sudo btrfs fi defrag -v -r /
	sudo btrfs balance start -dusage=20 /
	sudo mount -o remount ro /nix/store/


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

