# LibreWolf

```nix PereBook/home/librewolf.nix
{ config, pkgs, lib, ... }:
{
  programs.librewolf = {
    profiles.default.settings = {
      <<<PereBook/home/librewolf-settings>>>
    };
  };
}
```

## Settings

### Privacy

Enable DNS over HTTPS

```nix "PereBook/home/librewolf-settings" +=
"network.trr.mode" = 2;
```

