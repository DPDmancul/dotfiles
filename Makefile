.PHONY: update git-add
.PHONY: install install-system install-home
.PHONY: optimise collect-garbage defrag

NIX := nix --extra-experimental-features "nix-command flakes"
HOME-MANAGER := $(NIX) run .\#home-manager --

install: install-system install-home ;

update:
	$(NIX) flake update
	$(MAKE)

SOPS-NIX := /var/lib/sops-nix
install-system: .git-add
	sudo sh -c "[ -f $(SOPS-NIX)/key.txt ] || { mkdir -p $(SOPS-NIX); ln -s \"$$HOME/.config/sops/age/keys.txt\" $(SOPS-NIX)/key.txt; chmod 500 $(SOPS-NIX); }"
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

.git-add:
	git add .

