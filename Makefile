.PHONY: update unlock git-add
.PHONY: install install-system install-home
.PHONY: optimise collect-garbage defrag

NIX := nix --extra-experimental-features nix-command
HOME-MANAGER := $(NIX) run .\#home-manager --

install: install-system install-home ;

update:
	$(NIX) flake update
	$(MAKE)

install-system: .git-add
	sudo nixos-rebuild switch --flake .#

install-home: .git-add
	 rm -f ~/.config/mimeapps.list.bak ~/.local/share/applications/mimeapps.list.bak
	$(HOME-MANAGER) switch -b bak --flake .#$$USER@$$(hostname)

optimise:
	$(NIX) store optimise

collect-garbage:
	$(HOME-MANAGER) expire-generations "-30 days"
	sudo nix-collect-garbage --delete-older-than 90d
	$(MAKE) install-system # update the set of boot entries

defrag:
	sudo mount -o remount rw /nix/store/
	sudo btrfs fi defrag -v -r /
	sudo btrfs balance start -dusage=20 /
	sudo mount -o remount ro /nix/store/

unlock:
	git-crypt unlock

.git-add:
	git add .

