# System

```nix configuration.nix
{ config, pkgs, args, lib, ... }:
let secrets = import ./secrets.nix;
in {
  <<<config>>>
}
```

## Enable flakes

```nix "config" +=
nix.package = pkgs.nixFlakes;
nix.extraOptions = ''
  experimental-features = nix-command flakes
'';
```

## Channels

Use the same channel as the main of this flake for the system (e.g. legacy nix-shell)

```nix "config" +=
nix.nixPath = [
  "nixpkgs=${args.nixpkgs.outPath}"
];
```

## Hardware

Include the results of the hardware scan

```nix "config" +=
imports = [ 
  <<<system-imports>>>
  ./hardware-configuration.nix 
];

fileSystems."/home/dpd-/datos" = { 
  device = "/dev/disk/by-uuid/42681448-3710-4f0b-9778-994a23c7f17e";
  fsType = "ext4";
};
```

Enable BTRFS compression

```nix "config" +=
fileSystems."/".options = [ "compress=zstd" "noatime" ];
```

Disable emergency mode to avoid get stuck if a partition fails to mount

```nix "config" +=
systemd.enableEmergencyMode = false;
```

Enable pen tablet FOSS drivers

```nix "config" +=
hardware.opentabletdriver.enable = true;
```

Enable hardware video acceleration for Intel

```nix "config" +=
hardware.opengl = {
  enable = true;
  extraPackages = with pkgs; [
    intel-media-driver # LIBVA_DRIVER_NAME=iHD
    vaapiIntel         # LIBVA_DRIVER_NAME=i965
    vaapiVdpau
    libvdpau-va-gl
  ];
};
```

## Timezone

```nix "config" +=
time.timeZone = "Europe/Rome";
```

## Environment

```nix "config" +=
environment.sessionVariables = {
  <<<env>>>
};
```

## Enable NTFS support

```nix "config" +=
boot.supportedFilesystems = [ "ntfs" ];
```

## Optimise Nix store

Automatically de-duplicate for newer derivations

```nix "config" +=
nix.settings.auto-optimise-store = true;
```

## Sway

Sway is configured with home-manager but must be activated also at system level to set the environment (eg. opengl, dconf, ...)

```nix "config" +=
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = [];
};
```

## State version

**DO NOT TOUCH!**

```nix "config" +=
system.stateVersion = "21.11";
```

