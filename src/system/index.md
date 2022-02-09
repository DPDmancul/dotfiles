# System

```nix configuration.nix
{ config, pkgs, lib, ... }:
let secrets = import ../secrets.nix;
in {
  <<<config>>>
}
```

Include the results of the hardware scan

```nix "config" +=
imports = [ /etc/nixos/hardware-configuration.nix ];
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

## State version

**DO NOT TOUCH!**

```nix "config" +=
system.stateVersion = "21.11";
```

