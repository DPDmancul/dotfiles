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

## Qemu

Enable virtual GPUs to run in Qemu

```nix "config" +=
virtualisation.kvmgt.vgpus = true;
```

Fix cursor for Sway

```nix "env" +=
WLR_NO_HARDWARE_CURSORS = "1";
```

## State version

**DO NOT TOUCH!**

```nix "config" +=
system.stateVersion = "21.11";
```

