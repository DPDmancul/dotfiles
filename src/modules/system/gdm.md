# GDM (display manager)

```nix modules/system/gdm.nix
{ config, pkgs, lib, ... }:
{
  services.displayManager.gdm.enable = true;
}
```

