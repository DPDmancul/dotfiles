# Go

```nix modules/home/packages/developing/go.nix
{ config, pkgs, lib, ... }:
{
  programs.go = {
    enable = true;
    telemetry.mode = "off";
  };

  <<<modules/home/packages/developing/go>>>
}
```

### Neovim support

```nix "modules/home/packages/developing/go" +=
nvimLSP.gopls = pkgs.gopls;
```
