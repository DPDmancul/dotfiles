{ config, pkgs, lib, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal.config.niri = {
    default = [ "gnome" "gtk" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
  };

  security.pam.services.swaylock = {
      text = "auth include login";
  };
}
