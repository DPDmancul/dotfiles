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

## Keyboard mappings

Manage key mapping config at system level (for tty, X11 and Wayland).

```nix "config" +=
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

```nix "config" +=
# services.clamav = {
#   daemon.enable = true;
#   updater.enable = true;
# };
```
-->

