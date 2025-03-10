# Firefox

```nix PereBook/home/firefox.nix
{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        <<<PereBook/home/firefox-settings>>>
      };
    };
  };
}
```

## Settings

### Privacy

Enable DNS over HTTPS

```nix "PereBook/home/firefox-settings" +=
"network.trr.mode" = 2;
```

