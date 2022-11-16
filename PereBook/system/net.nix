{ config, pkgs, assets, secrets, lib, ... }:
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

  services.openvpn.servers = {
    vpn  = {
      config = "config ${assets}/it238.nordvpn.com.udp.ovpn";
      updateResolvConf = true;
      authUserPass = secrets.vpn;
    };
  };
}
