.PHONY: update unlock git-add
.PHONY: install install-system install-home
.PHONY: optimize collect-garbage defrag

NIX := nix --extra-experimental-features nix-command

install: install-system install-home ;

update:
	$(NIX) flake update
	sudo nix-channel --update
	$(MAKE) all

install-system: git-add
	sudo nixos-rebuild switch --flake '.#'

install-home: git-add
	home-manager switch -b bak -f "./home.nix"

optimise:
	$(NIX) store optimise

collect-garbage:
	home-manager expire-generations "-30 days"
	sudo nix-collect-garbage --delete-older-than 90d
	$(MAKE) install-system # update the set of boot entries

defrag:
	sudo mount -o remount rw /nix/store/
	sudo btrfs fi defrag -v -r /
	sudo btrfs balance start -dusage=20 /
	sudo mount -o remount ro /nix/store/

unlock:
	git-crypt unlock

git-add:
	git add .

