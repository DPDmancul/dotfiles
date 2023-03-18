{ config, pkgs, lib, ... }:
{
  services.autorandr = {
    profiles = {
      # "scrivanie" = {
      #   fingerprint = {
      #     DP-6 = "";
      #     DP-4 = "";
      #     eDP-1 = "";
      #   };
      #   config = {
      #     DP-6.position = "0x0";
      #     DP-4.position = "2560x0";
      #     eDP-1.position = "5120x0";
      #   };
      # };
    };
  };

  services.xserver.dpi = 100;
}
