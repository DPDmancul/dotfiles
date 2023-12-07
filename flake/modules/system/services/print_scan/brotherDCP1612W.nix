{ config, pkgs, lib, ... }:
let
  ip = "192.168.1.4";
  model = "DCP-1612W";
in
{
  imports = [
    ../print_scan.nix
  ];
  config = {
    services.printing.drivers = with pkgs; [
      brlaser-master
    ];
    hardware.printers = {
      ensureDefaultPrinter = "Brother";
      ensurePrinters = [{
        name = "Brother";
        location = "cjase";
        description = "Brother ${model}";
        deviceUri = "ipp://${ip}/ipp";
        model = "drv:///brlaser.drv/br1600.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }];
    };
    hardware.sane.brscan4 = {
      enable = true;
      netDevices = {
        cjase = { inherit model ip; };
      };
    };
  };
}
