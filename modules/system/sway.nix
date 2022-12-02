{ config, pkgs, lib, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };
  security.pam.services.swaylock = {
    text = "auth include login";
  };
}
