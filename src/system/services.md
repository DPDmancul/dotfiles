# Services

## D-Bus

Required by many other services (e.g. `xdg-desktop-portal`)

```nix "config" +=
services.dbus.enable = true;
```

## CUPS

Enable printing

```nix "config" +=
services.printing.enable = true;
```

## SSH

Enable OpenSSH daemon

```nix "config" +=
services.openssh.enable = true;
programs.ssh.startAgent = true;
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

