# Disko

```nix PereBook/system/disko.nix
{ config, lib, ... }:
{
  disko.devices.disk = {
    <<<PereBook/system/disko>>>
  };
}
```

## Main disk

```nix "PereBook/system/disko" +=
main = {
  type = "disk";
  device = "/dev/nvme0n1";
  content = {
    type = "gpt";
    partitions = {
      <<<PereBook/system/disko-main>>>
    };
  };
};
```

### EFI System Partition

```nix "PereBook/system/disko-main" +=
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

```nix "PereBook/system/disko-main" +=
root = {
  size = "100%";
  content = {
    type = "luks";
    name = "crypted";
    settings = {
      allowDiscards = true; # enable trim
    };
    content = {
      type = "btrfs";
      subvolumes = {
        <<<PereBook/system/disko-main-subvols>>>
      };
    };
  };
};
```

#### NixOs subvolume

```nix "PereBook/system/disko-main-subvols" +=
"nixos" = {
  mountpoint = "/";
  mountOptions = [
    "compress=zstd"
    "noatime"
  ];
};
```

#### Home subvolume

```nix "PereBook/system/disko-main-subvols" +=
"nixos/home" = { };
```

#### Nix store subvolume

```nix "PereBook/system/disko-main-subvols" +=
"nixos/nix" = { };
```

#### Swap subvolume

```nix "PereBook/system/disko-main-subvols" +=
"swap" = {
  mountpoint = "/.swapvol";
  swap.swapfile.size = "8G";
};
```

