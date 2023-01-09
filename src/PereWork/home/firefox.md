# Firefox

```nix PereWork/home/firefox.nix
{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        <<<PereWork/home/fiefox-settings>>>
      };
    };
  };
}
```

## Settings

Restore previous session on startup

```nix "PereWork/home/fiefox-settings" +=
"browser.startup.page" = 3;
```

