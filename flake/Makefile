.PHONY: update git-add
.PHONY: install test
.PHONY: optimise collect-garbage defrag

NIX := nix --extra-experimental-features "nix-command flakes"

install:
	sudo nixos-rebuild switch --flake .#

test:
	sudo nixos-rebuild test --flake .#

update:
	$(NIX) flake update
	$(MAKE)

optimise:
	$(NIX) store optimise

collect-garbage:
	sudo nix-collect-garbage --delete-older-than 90d
#	$(MAKE) install # update the set of boot entries

defrag:
	sudo mount -o remount rw /nix/store/
	sudo btrfs fi defrag -v -r /
	sudo btrfs balance start -dusage=20 /
	sudo mount -o remount ro /nix/store/

