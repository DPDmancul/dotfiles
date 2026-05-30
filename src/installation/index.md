# Install NixOS

1. Run the live image of NixOS.
2. Switch to root:
   ```sh
   sudo -i
   ```

3. Connect to the network following the guide.

   It could be useful to read the guide while doing installation:
   ```sh
   screen
   nixos-help
   # C-a S
   # C-a tab
   # C-a c
   # Switch region with C-a tab
   ```

4. Generate hardware config.

   From dotfiles folder:
   ```sh
   nixos-generate-config --root /tmp/config --no-filesystems
   cp /tmp/config/hardware-configuration.nix {src,flake}/$machine/system/
   git add {src,flake}/$machine/system/hardware-configuration.nix
   git commit -m 'Added hardware configuration'
   git push
   ```

5. Partition the disk and install the system.

   ```sh
   cd flake
   nix run disko#disko-install -- --write-efi-boot-entries -f .#$machine --disk main $dev
   ```
6. Copy your sops key.

   ```sh
   cp sops-key.txt /mnt{/var/lib/sops-nix/key.txt,/home/$user/.config/sops/age/keys.txt}
   chmod 500 /mnt/var/lib/sops-nix;
   ```

7. Copy the dotfiles into `/mnt/home/$user/.dotfiles`
8. Reboot
9. Complete installation:

   ```sh
   cd .dotfiles
   nix-shell
   make install
   ```

