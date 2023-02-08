# Home

```nix PereBook/home/default.nix
{ config, pkgs, lib, modules, assets, ... }:
{
  imports = [
    /${modules}/home
    /${modules}/home/gnome
    ./packages.nix
  ];

  <<<PereBook/home>>>
}
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
