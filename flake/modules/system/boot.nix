{ config, pkgs, lib, ... }:
{
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Remove old generation profiles to avoid
      # have a full boot partition
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.loader.timeout = 2;
  boot.tmp.useTmpfs = true;
}
