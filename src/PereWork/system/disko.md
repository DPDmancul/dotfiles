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
  end = "-8G";
  content = {
    type = "luks";
    name = "crypted";
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
  size = "100%";
  content.type = "swap";
};
```

