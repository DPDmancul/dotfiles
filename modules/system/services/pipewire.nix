{ config, pkgs, lib, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };
  security.rtkit.enable = true;
  xdg.portal.wlr.enable = true;
  services.pipewire.media-session.config.bluez-monitor.rules = [
    {
      # Matches all cards
      matches = [{ "device.name" = "~bluez_card.*"; }];
      actions = {
        "update-props" = {
          "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
          "bluez5.msbc-support" = true;
          "bluez5.sbc-xq-support" = true;
        };
      };
    }
    {
      matches = [
        # Matches all sources
        { "node.name" = "~bluez_input.*"; }
        # Matches all outputs
        { "node.name" = "~bluez_output.*"; }
      ];
      actions = {
        "node.pause-on-idle" = false;
      };
    }
  ];
}