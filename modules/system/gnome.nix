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
}
