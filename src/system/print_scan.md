# Printer and scanner

## Printer

Enable printing and CUPS GUI frontend

```nix "config" +=
services.printing = {
  enable = true;
  drivers = with pkgs; [ 
    brlaser 
  ];
};
programs.system-config-printer.enable = true;
```

### Brother DCP 1612W network printer

```nix "config" +=
hardware.printers = {
  ensureDefaultPrinter = "Brother";
  ensurePrinters = [{
    name = "Brother";
    location = "cjase";
    description = "Brother DCP 1612W";
    deviceUri = "ipp://192.168.1.4/ipp";
    model = "drv:///brlaser.drv/br1600.ppd";
    ppdOptions = {
      PageSize = "A4";
    };
  }];
};
```

## Scanner

Enable scanning

```nix "config" +=
hardware.sane.enable = true;
```

Add user to the required groups

```nix "user-groups" +=
"scanner"
"lp"
```

### Brother DCP 1612W network scanner

Import the driver

```nix "system-imports" +=
(args.nixpkgs + "/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix")
```

The driver is unfortunately unfree

```nix "extra-packages-unfree" +=
brscan4
brscan4-etc-files
brother-udev-rule-type1
```

```nix "config" +=
hardware.sane.brscan4 = {
  enable = true;
  netDevices = {
    cjase = { model = "DCP-1612W"; ip = "192.168.1.4"; };
  };
};
```


