# Pipewire

Use PipeWire as multimedia framework

```nix modules/system/services/pipewire.nix
{ config, pkgs, lib, ... }:
{
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  <<<modules/system/services/pipewire>>>
}
```

Use RealtimeKit to permit PipeWire acquiring realtime priority

```nix "modules/system/services/pipewire" +=
security.rtkit.enable = true;
```

## Bluetooth headsets

Use mSBC and SBC-XQ codes for better quality

```nix "modules/system/services/pipewire" +=
environment.etc = {
  "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
    bluez_monitor.properties = {
      ["bluez5.enable-sbc-xq"] = true,
      ["bluez5.enable-msbc"] = true,
      ["bluez5.enable-hw-volume"] = true,
      ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
    }
  '';
};
```

