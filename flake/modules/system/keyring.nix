{ config, pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
}
