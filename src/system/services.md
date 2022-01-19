# Services

## CUPS

Enable printing

```nix "config" +=
services.printing.enable = true;
```

## SSH

Enable OpenSSH daemon

```nix "config" +=
services.openssh.enable = true;
```
<!--
## Antivirus

```nix "config" +=
# services.clamav = {
#   daemon.enable = true;
#   updater.enable = true;
# };
```
-->

