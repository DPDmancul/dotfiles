# Custom packages

Load all custom packages as overlay.

```nix pkgs/default.nix
{ pkgs, lib }:
  with lib; with builtins;
  genAttrs
    (filter (name: name != "default")
      (concatMap (match "(.*)\.nix") (attrNames (readDir ./.))))
    (pkg: pkgs.callPackage ./${pkg}.nix { })
```
