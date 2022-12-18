# Zoxide and fzf

Use zoxide and fzf for fuzzy cd

```nix modules/home/zoxide.nix
{ config, pkgs, lib, ... }:
{
  programs = {
    zoxide.enable = true;
    fzf.enable = true;
  };
}
```
