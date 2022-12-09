{ config, pkgs, lib, ... }:
{
  networking = {
    useDHCP = false;
    # TODO:
    # interfaces.enp7s0.useDHCP = true;
    # interfaces.wlp6s0.useDHCP = true;
  };
}
