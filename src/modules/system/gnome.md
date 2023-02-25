# Gnome (desktop environment)

Enable Gnome and GDM with X11 <!-- and Wayland -->. 

```nix modules/system/gnome.nix
{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      # wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  <<<modules/system/gnome>>>
}
```

Remove default useless applications

```nix "modules/system/gnome" +=
services.gnome.core-utilities.enable = false;
services.xserver.desktopManager.xterm.enable = false;
environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
]) ++ (with pkgs.gnome; [
  gnome-terminal
  gedit
  geary
  evince
]);
```
