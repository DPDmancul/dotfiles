.PHONY: update unlock
.PHONY: install install-system install-home
.PHONY: optimize collect-garbage defrag

install: install-system install-home

update:
	sudo nix-channel --update
	$(MAKE) all

install-system:
	sudo nixos-rebuild switch -I nixos-config="./configuration.nix"

install-home:
	home-manager switch -b bak -f "./home.nix"

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

unlock:
	git-crypt unlock

