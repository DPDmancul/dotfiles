# System

Here is collected the common config for all systems.

In this folder there are also some useful modules used only by some system configs.

```nix modules/system/default.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./flakes.nix
    ./boot.nix
    ./i18n.nix
  ];

  <<<modules/system>>>
}
```

Disable storing file last access time to improve disk performances

```nix "modules/system" +=
fileSystems."/".options = [ "noatime" ];
```

Disable emergency mode to avoid get stuck if a partition fails to mount

```nix "modules/system" +=
systemd.enableEmergencyMode = false;
```

Enable OpenGL

```nix "modules/system" +=
hardware.opengl.enable = true;
```

Enable NTFS support

```nix "modules/system" +=
boot.supportedFilesystems = [ "ntfs" ];
```

Enable NetworkManager

```nix "config" +=
networking.networkmanager.enable = true;
```

## Optimise Nix store

Automatically de-duplicate for newer derivations

```nix "modules/system" +=
nix.settings.auto-optimise-store = true;
```

## State version

**DO NOT TOUCH!**

```nix "modules/system" +=
system.stateVersion = "21.11";
```

