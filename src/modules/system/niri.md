# Niri (window manager)

Niri is configured with home-manager but must be activated also at system level to set the environment (eg. opengl, dconf, …)

```nix modules/system/niri.nix
{ config, pkgs, lib, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  <<<modules/system/niri>>>
}
```

## Swaylock

Grant PAM access to swaylock

```nix "modules/system/niri" +=
security.pam.services.swaylock = {
    text = "auth include login";
};
```

