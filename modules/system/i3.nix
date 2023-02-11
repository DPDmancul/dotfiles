{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      package = pkgs.unstable.i3; # TODO stable after gaps being merged
      extraPackages = [ ];
    };
  };
}
