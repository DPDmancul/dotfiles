# Disko

```nix PereWork/system/disko.nix
{ config, lib, ... }:
{
  disko.devices.disk = {
    <<<PereWork/system/disko>>>
  };
}
```

## Main disk

```nix "PereWork/system/disko" +=
main = {
  type = "disk";
  device = "/dev/nvme0n1";
  content = {
    type = "gpt";
    partitions = {
      <<<PereWork/system/disko-main>>>
    };
  };
};
```

### EFI System Partition

```nix "PereWork/system/disko-main" +=
ESP = {
  uuid = "97b9c8c2-208f-4810-9329-7d61152a32ab";
  size = "512M";
  type = "EF00";
  content = {
    type = "filesystem";
    format = "vfat";
    mountpoint = "/boot";
    mountOptions = [ "umask=0077" ];
  };
};
```

### Root partition

Encrypt the root partition with LUKS

```nix "PereWork/system/disko-main" +=
root = {
  uuid = "d86f9641-525b-4d11-b2c1-72737cc093a7";
  end = "-8G";
  content = {
    type = "luks";
    name = "nixenc";
    settings = {
      allowDiscards = true; # enable trim
    };
    content = {
      type = "btrfs";
      subvolumes = {
        <<<PereWork/system/disko-main-subvols>>>
      };
    };
  };
};
```

#### NixOs subvolume

```nix "PereWork/system/disko-main-subvols" +=
"nixos" = {
  mountpoint = "/";
  mountOptions = [
    "compress=zstd"
    "noatime"
  ];
};
```

#### Home subvolume

```nix "PereWork/system/disko-main-subvols" +=
"nixos/home" = { };
```

### Swap

```nix "PereWork/system/disko-main" +=
swap = {
  uuid = "28b1656d-fae8-41f6-8207-851e0d87dbd9";
  size = "100%";
  content.type = "swap";
};
```

