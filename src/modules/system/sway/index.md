# Sway (window manager)

Sway is configured with home-manager but must be activated also at system level to set the environment (eg. opengl, dconf, ...)

```nix modules/system/sway.nix
{ config, pkgs, lib, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };
  <<<modules/system/sway>>>
}
```
Grant PAM access to swaylock

```nix "modules/system/sway" +=
security.pam.services.swaylock = {
  text = "auth include login";
};
```

