{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;

    displayManager.lightdm = {
      enable = !config.services.xserver.displayManager.gdm.enable;
    };
  };
}
