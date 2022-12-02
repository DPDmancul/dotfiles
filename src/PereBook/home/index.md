# Home

```nix PereBook/home/default.nix
{ config, pkgs, lib, modules, assets, ... }:
{
  imports = [
    /${modules}/home
    # Nvim
    /${modules}/home/sway
    ./packages.nix
  ];

  <<<home-config>>>
  # TODO remove previous in favour of
  <<<PereBook/home>>>
}

```
## Environment

<!-- TODO: remove -->

```nix "home-config" +=
home.sessionVariables = {
  <<<home-env>>>
};
home.sessionPath = [
  <<<home-path>>>
];
```

## Bluetooth headset battery

```nix "PereBook/home" +=
home.packages = with pkgs; [
  (pkgs.writeShellScriptBin "batt" ''
    ${bluetooth_battery}/bin/bluetooth_battery AC:12:2F:50:BB:3A
  '')
];
```

## OpenTabletDriver config

```nix "PereBook/home" +=
xdg.configFile."OpenTabletDriver/settings.json".source = /${assets}/tablet.json;
```
