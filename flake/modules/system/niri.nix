{ config, pkgs, lib, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  security.pam.services.swaylock = {
      text = "auth include login";
  };
}
