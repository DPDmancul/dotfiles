# Flakes

```nix modules/system/flakes.nix
{ config, inputs, pkgs, lib, ... }:
{
  <<<modules/system/flakes>>>
}
```

Better integration of system with flakes

## Enable flakes

```nix "modules/system/flakes" +=
nix.settings.experimental-features = "nix-command flakes";
```

## Registries and Channels

Use the same registries and channels as this flake for the system (e.g. legacy nix-shell)

```nix "modules/system/flakes" +=
nix = {
  registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
  nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
};
```

