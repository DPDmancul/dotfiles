# Services

```nix modules/system/services/default.nix
{ config, pkgs, lib, ... }:
{
  <<<modules/system/services>>>

  environment.systemPackages = with pkgs; [
    <<<modules/system/services-packages>>>
  ];
}
```

## D-Bus

Required by many other services (e.g. `xdg-desktop-portal`)

```nix "modules/system/services" +=
services.dbus.enable = true;
```

## Xdg desktop portal

The gnome portal is required for screen cast, but it would require nautilus for file chooser.

```nix "modules/system/services" +=
xdg.portal = {
  enable = true;
  extraPortals = [ 
    pkgs.xdg-desktop-portal-gnome 
    pkgs.xdg-desktop-portal-gtk
  ];

  config = {
    common = {
      default = [ "gnome" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };
};
```

## Bluetooth

```nix "modules/system/services" +=
hardware.bluetooth.enable = true;
services.blueman.enable = true;
```

## Virtual filesystems

```nix "modules/system/services" +=
services.gvfs.enable = true;
```

### Mount removable devices

```nix "modules/system/services" +=
services.udisks2.enable = true;
```

## SSH

Enable OpenSSH daemon

```nix "modules/system/services" +=
services.openssh.enable = true;
programs.ssh.startAgent = !config.services.gnome.gcr-ssh-agent.enable;
```

## Keyboard mappings

Manage key mapping config at system level (for tty, X11 and Wayland).

```nix "modules/system/services" +=
environment.etc."dual-function-keys.yaml".text = ''
  MAPPINGS:
    <<<dual-function-keys-mappings>>>
'';
services.interception-tools = {
  enable = true;
  plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
  udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY:
            <<<interception-tools-keys>>>
  '';
  };
```

### Better capslock

Use `caps` as `esc` (one tap) or `ctrl` (long press) 

```yaml "interception-tools-keys" +=
- KEY_CAPSLOCK
```

```yaml "dual-function-keys-mappings" +=
- KEY: KEY_CAPSLOCK
  TAP: KEY_ESC
  HOLD: KEY_LEFTCTRL
```

Just in case it could be needed remap `caps` from `right ctrl`

```yaml "interception-tools-keys" +=
- KEY_RIGHTCTRL
```

```yaml "dual-function-keys-mappings" +=
- KEY: KEY_RIGHTCTRL
  TAP: KEY_CAPSLOCK
  HOLD: KEY_RIGHTCTRL
```

<!--
## Antivirus

```nix "modules/system/services" +=
# services.clamav = {
#   daemon.enable = true;
#   updater.enable = true;
# };
```
-->

## Autorandr

```nix "modules/system/services" +=
services.autorandr = {
  enable = true;
  defaultTarget = "horizontal";
};
```

## Backlight control

```nix "modules/system/services-packages" +=
brightnessctl
```

## FHS support

Enable FHS support for unpatched programs with nix-ld


```nix "modules/system/services" +=
programs.nix-ld.enable = true;
```

## Firmware update

```nix "modules/system/services" +=
services.fwupd.enable = true;
```

