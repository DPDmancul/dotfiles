{ config, pkgs, lib, ... }:
{
  services.autorandr = {
    profiles = {
      # "scrivanie" = {
      #   fingerprint = {
      #     DP-? = "";
      #     DP-? = "";
      #     DP-4 = "00ffffffffffff0006afed6100000000001a010495221378025925935859932926505400000001010101010101010101010101010101783780b470382e406c30aa0058c1100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231353648414e30362e31200a00ea";
      #   };
      #   config = {
      #     DP-?.position = "0x0";
      #     DP-?.position = "2560x0";
      #     DP-4.position = "5120x0";
      #   };
      # };
    };
  };

  services.xserver.dpi = 96;
}
