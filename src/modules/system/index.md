# System

Here is collected the common config for all systems.

In this folder there are also some useful modules used only by some system configs.

```nix modules/system/default.nix
{ config, pkgs, users, lib, assets, ... }:
{
  imports = [
    ./flakes.nix
    ./boot.nix
    ./i18n.nix
    ./services
    ./services/net.nix
    ./services/pipewire.nix
    ./services/print_scan.nix
    ./services/docker.nix
    ./lightdm.nix
    ./i3.nix
    ./keyring.nix
    ./packages.nix
  ];

  sops.defaultSopsFile = /${assets}/secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  users.users = lib.genAttrs users (user: {
    extraGroups = [
      "input"
      "video"
    ];
  });

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

Users must follow this config and cannot be modified outside it

```nix "modules/system" +=
users.mutableUsers = false;
```

Enable dconf

```nix "modules/system" +=
programs.dconf.enable = true;
```

## Timezone

```nix "modules/system" +=
time.timeZone = "Europe/Rome";
```

## Fonts

```nix "modules/system" +=
fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fontconfig = {
    defaultFonts = {
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "DejaVu Sans" ];
      monospace = [ "JetBrainsMono" ];
    };
  };
};
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

