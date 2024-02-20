{ config, pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;

# Enable automatic unlock
  security.pam.services = {
    login.enableGnomeKeyring = true;
    lightdm.enableGnomeKeyring = config.services.xserver.displayManager.lightdm.enable;
    gdm.enableGnomeKeyring = config.services.xserver.displayManager.gdm.enable;
  };
}
