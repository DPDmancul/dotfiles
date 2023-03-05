# Custom overlays

Load all custom overlays.

```nix overlays/default.nix
with builtins; map
  (overlay: import ./${overlay}.nix)
  (filter (name: name != "default")
    (concatMap (match "(.*)\.nix") (attrNames (readDir ./.))))
```

