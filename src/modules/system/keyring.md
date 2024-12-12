# Gnome Keyring

Enable Gnome Keyring and seahorse

```nix modules/system/keyring.nix
{ config, pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
```
