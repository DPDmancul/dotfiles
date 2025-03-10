# LibreWolf

```nix PereWork/home/librewolf.nix
{ config, pkgs, lib, ... }:
{
  programs.librewolf = {
    profiles.default.settings = {
      <<<PereWork/home/librewolf-settings>>>
    };
  };
}
```

## Settings

Restore previous session on startup

```nix "PereWork/home/librewolf-settings" +=
"browser.startup.page" = 3;
```

