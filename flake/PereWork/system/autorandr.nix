{ config, pkgs, lib, ... }:
{
  services.autorandr = {
    profiles = let
      common = {
        gamma = "1.099:1.0:0.909";
        # x-prop-non_desktop = 0;
      };
      laptop-base-config = common // {
        mode = "1920x1080";
        rate = "60.05";
      };
      external-base-config = common // {
        mode = "2560x1440";
        rate = "59.95";
      };
      DP-4 = "00ffffffffffff0006afed6100000000001a010495221378025925935859932926505400000001010101010101010101010101010101783780b470382e406c30aa0058c1100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231353648414e30362e31200a00ea";
    in {
      "scrivanie" = {
        fingerprint = {
          "DP-3.1.8" = "00ffffffffffff0022f0163200000000161a0104a53c22783a4455a9554d9d260f5054210800d1c0a9c081c0d100b3009500a9408180565e00a0a0a029503020350055502100001a000000fd00323c1e5a19000a202020202020000000fc004850205a32376e0a2020202020000000ff00434e4b3632323137394a0a2020018f020312f149101f0413031202110123090707023a801871382d40582c450055502100001ff33980d072382d40102c450055502100001f011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e9600555021000019d50980a020e02d101060a200555021000018000000000000000000000000000000000000009c";
          "DP-3.8" = "00ffffffffffff0022f0163200000000121a0104a53c22783a4455a9554d9d260f5054210800d1c0a9c081c0d100b3009500a9408180565e00a0a0a029503020350055502100001a000000fd00323c1e5a19000a202020202020000000fc004850205a32376e0a2020202020000000ff00434e4b36313830304c5a0a20200173020312f149101f0413031202110123090707023a801871382d40582c450055502100001ff33980d072382d40102c450055502100001f011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e9600555021000019d50980a020e02d101060a200555021000018000000000000000000000000000000000000009c";
          inherit DP-4;
        };
        config = {
          "DP-3.1.8" = external-base-config // { position = "0x0"; };
          "DP-3.8" = external-base-config // { position = "2560x0"; primary = true; };
          DP-4 = laptop-base-config // { position = "5120x360"; };
        };
      };
      "enbl1" = {
        fingerprint = {
          DP-1 = "00ffffffffffff0022f0193201010101161a0103803c22782a4455a9554d9d260f5054210800d1c0a9c081c0d100b3009500a9408180565e00a0a0a029503020350055502100001a000000fd00323c1e5a19000a202020202020000000fc004850205a32376e0a2020202020000000ff00434e4b363232313330480a202001cd02031ff14b101f0413031202110105142309070767030c0010000036e2002b023a801871382d40582c450055502100001ff33980d072382d40102c450055502100001f011d007251d01e206e28550055502100001e8c0ad08a20e02d10103e9600555021000019d50980a020e02d101060a200555021000018000000000000ab";
          inherit DP-4;
        };
        config = {
          DP-1 = external-base-config // { position = "0x0"; };
          DP-4 = laptop-base-config // { position = "320x1440"; };
        };
      };
    };
  };

  services.xserver.dpi = 96;
}
