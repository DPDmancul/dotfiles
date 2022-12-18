{ config, pkgs, lib, ... }:
{
  networking = {
    useDHCP = false;
    # interfaces.enp0s31f6.useDHCP = true;
    # interfaces.wlp4s0.useDHCP = true;
  };
}
