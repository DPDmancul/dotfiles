# GnuPG

Enable Gnu Privacy Guard

```nix modules/home/gpg.nix
{ config, pkgs, lib, ... }:
{
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gtk2;
  };
}
```
