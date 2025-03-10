# Firefox

```nix PereWork/home/firefox.nix
{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        <<<PereWork/home/firefox-settings>>>
      };
    };
  };
}
```

## Settings

Restore previous session on startup

```nix "PereWork/home/firefox-settings" +=
"browser.startup.page" = 3;
```

