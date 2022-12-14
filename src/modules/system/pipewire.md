# Pipewire

Use PipeWire as multimedia framework

```nix modules/system/services/pipewire.nix
{ config, pkgs, lib, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };
  <<<modules/system/services/pipewire>>>
}
```

Use RealtimeKit to permit PipeWire acquiring realtime priority

```nix "modules/system/services/pipewire" +=
security.rtkit.enable = true;
```

## xdg portal

Enable xdg portal, required by pipewire to share screen:

```nix "modules/system/services/pipewire" +=
xdg.portal.wlr.enable = true;
```


## Bluetooth headsets

Use mSBC and SBC-XQ codes for better quality

```nix "modules/system/services/pipewire" +=
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
```

