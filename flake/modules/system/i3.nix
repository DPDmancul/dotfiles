{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = [ ];
    };
  };
}
