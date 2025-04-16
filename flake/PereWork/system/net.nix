{ config, pkgs, assets, lib, ... }:
{
  sops.secrets = {
    "vpn/openvpn-config-office" = {};
    "vpn/openvpn-credentials-office" = {};
  };

  services.openvpn.servers = {
    office  = {
      config = ''
        config ${config.sops.secrets."vpn/openvpn-config-office".path}
        auth-user-pass ${config.sops.secrets."vpn/openvpn-credentials-office".path}
      '';
      updateResolvConf = true;
      autoStart = false;
    };
  };
}
