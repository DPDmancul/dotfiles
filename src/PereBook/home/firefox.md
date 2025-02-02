# Firefox

```nix PereBook/home/firefox.nix
{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    profiles.default = {
      settings = {
        <<<PereBook/home/fiefox-settings>>>
      };
    };
  };
}
```

## Settings

### Privacy

Enable DNS over HTTPS

```nix "PereBook/home/fiefox-settings" +=
"network.trr.mode" = 2;
```

