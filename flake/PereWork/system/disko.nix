{ config, lib, ... }:
{
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          swap = {
            size = "100%";
            content.type = "swap";
          };
        };
      };
    };
  };
}
