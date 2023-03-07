{ config, pkgs, assets, lib, ... }:
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
    kernelModules = [ "8821cu" ];
  };
  sops.secrets."vpn/nordvpn.nmconnection".path = "/etc/NetworkManager/system-connections/nordvpn.nmconnection";
  sops.secrets."vpn/it238.nordvpn.com.udp-ca.pem".path = "/root/.cert/nm-openvpn/it238.nordvpn.com.udp-ca.pem";
  sops.secrets."vpn/it238.nordvpn.com.udp-tls-auth.pem".path = "/root/.cert/nm-openvpn/it238.nordvpn.com.udp-tls-auth.pem";
}
