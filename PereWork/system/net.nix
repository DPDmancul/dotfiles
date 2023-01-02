{ config, pkgs, lib, ... }:
{
  # networking.bonds.bond0 = {
  #   interfaces = [ "enp0s31f6" "wlp4s0" ];
  #   driverOptions = {
  #     miimon = "100";
  #     mode = "active-backup";
  #     primary = "enp0s31f6";
  #   };
  # };
  # systemd.network.networks.enp0s31f6.networkConfig.PrimarySlave = true;
}
