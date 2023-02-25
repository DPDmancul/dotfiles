{ config, pkgs, lib, ... }:
{
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.unstable.i3; # TODO stable after gaps being merged
      extraPackages = [ ];
    };
  };

# programs.xfconf.enable = true; # TODO TEST
#
#   environment.systemPackages = with pkgs.xfce; [
#     xfce4-panel
#     xfce4-i3-workspaces-plugin
#     xfce4-windowck-plugin
#     xfce4-pulseaudio-plugin
#     xfce4-battery-plugin
#   ];
#
#   environment.pathsToLink = [
#     "/share/xfce4"
#     "/lib/xfce4"
#   ];
}
