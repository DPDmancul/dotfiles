# LightDM (display manager)

```nix modules/system/lightdm.nix
{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;

    displayManager.lightdm = {
      enable = !config.services.displayManager.gdm.enable;
    };
  };
}
```

