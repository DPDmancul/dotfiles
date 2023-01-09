{ config, pkgs, assets, lib, ... }:
{
  networking = {
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
    interfaces.wlp6s0.useDHCP = true;
  };
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ rtl8821cu ];
    kernelModules = [ "8821cu" ];
  };
  networking.enableIPv6 = false;

  sops.secrets."vpn/openvpn-credentials-nordvpn" = {};
  services.openvpn.servers = {
    vpn  = {
      config = ''
        config ${assets}/it238.nordvpn.com.udp.ovpn
        auth-user-pass ${config.sops.secrets."vpn/openvpn-credentials-nordvpn".path}
      '';
      updateResolvConf = true;
    };
  };
}
