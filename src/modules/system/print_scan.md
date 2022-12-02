# Printer and scanner

## Printer

Enable printing, CUPS GUI frontend and scanning.

```nix modules/system/services/print_scan.nix
{ config, pkgs, users, lib, ... }:
{
  services.printing.enable = true;
  programs.system-config-printer.enable = true;
  hardware.sane.enable = true;
  <<<modules/system/services/print_scan>>>
}
```

Add user to the required groups

```nix "modules/system/services/print_scan" +=
users.users = lib.genAttrs users (user: {
  extraGroups = [
    "scanner"
    "lp"
  ];
});
```

### Brother DCP 1612W network printer

```nix modules/system/services/print_scan/brotherDCP1612W.nix
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
      brlaser
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
    <<<modules/system/services/print_scan/brotherDCP1612W>>>
  };
}
```

The driver is unfortunately unfree

```nix "unfree-extra" +=
"brscan4"
"brscan4-etc-files"
"brother-udev-rule-type1"
```

```nix "modules/system/services/print_scan/brotherDCP1612W" +=
hardware.sane.brscan4 = {
  enable = true;
  netDevices = {
    cjase = { inherit model ip; };
  };
};
```

