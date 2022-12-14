# Networking

```nix PereWork/system/net.nix
{ config, pkgs, lib, ... }:
{
  <<<PereWork/system/net>>>
}
```

## DHCP

The global useDHCP flag is deprecated, therefore explicitly set to false here.

Per-interface useDHCP will be mandatory in the future, so this config replicates the default behaviour.

```nix "PereWork/system/net" +=
networking = {
  useDHCP = false;
  # TODO:
  # interfaces.enp7s0.useDHCP = true;
  # interfaces.wlp6s0.useDHCP = true;
};
```

