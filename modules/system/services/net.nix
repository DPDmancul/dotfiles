{ config, pkgs, assets, lib, users, ... }:
{
  networking = {
    useNetworkd = true;
    wireless.iwd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    iwgtk
  ];
  systemd.network.wait-online = {
    anyInterface = true;
    timeout = 0;
  };
  # networking.bonds.bond0 = {
  #   interfaces = [
  #     "enp7s0"
  #     "wlan0"
  #   ];
  #   driverOptions.mode = "active-backup";
  # };
  sops.secrets."wireless.env".sopsFile = /${assets}/secrets/wireless.yaml;

  networking.wireless = {
    environmentFile = config.sops.secrets."wireless.env".path;
    networks = {
      IDR_CASA.psk = "@IDR_CASA_PSK@";
      "MV Labs Guests".psk = "@MV_Labs_Guests_PSK@";
    };
  };
}
